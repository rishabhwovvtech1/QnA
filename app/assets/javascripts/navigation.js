var HeaderManager = function (selectors) {
    this.nav = $(selectors.nav);
    this.mainContainer = $(selectors.mainContainer);
    this.expandBtn = $(selectors.expandBtn);
    this.collapseBtn = $(selectors.collapseBtn);
    this.navOption = $(selectors.navOption);
    this.navDropdownOption = $(selectors.navDropdownOption);
    this.dropdownToggle = $(selectors.dropdownToggle);
    this.homeButton = $(selectors.homeButton);
};

HeaderManager.prototype.init = function () {
    this.expandBtnClick();
    this.collapseBtnClick();
    this.navOptionClick();
    this.navDropdownOptionClick();
    this.homeButtonClick();
};

HeaderManager.prototype.homeButtonClick = function () {
    var _this = this;
    this.homeButton.click(function() {
        localStorage.pathname = '/admin';
    })
};

HeaderManager.prototype.expandBtnClick = function () {
    var _this = this;
    this.expandBtn.click(function(){
        _this.nav.removeClass('collapsed').addClass('expanded');
        _this.mainContainer.removeClass('collapsed').addClass('expanded');
        _this.expandBtn.addClass('hide');
        _this.collapseBtn.removeClass('hide');
        _this.dropdownToggle.attr('data-toggle','dropdown');
        $('.bold-header-text').removeClass('bold-header-text-collapsed');
        $('.nav-option.active').find('[data-toggle=dropdown]').dropdown('toggle');
        localStorage.navstate = $('#nav-container').html();
    });
};

HeaderManager.prototype.collapseBtnClick = function () {
    var _this = this;
    this.collapseBtn.click(function(){
        _this.nav.addClass('collapsed').removeClass('expanded');
        _this.mainContainer.addClass('collapsed').removeClass('expanded');
        _this.expandBtn.removeClass('hide');
        _this.collapseBtn.addClass('hide');
        _this.dropdownToggle.removeAttr('data-toggle');
        $('.open').removeClass('open');
        $('.bold-header-text').addClass('bold-header-text-collapsed');
        localStorage.navstate = $('#nav-container').html();
    });
};

HeaderManager.prototype.navOptionClick = function () {
    this.navOption.click(function(){
        if(!($(this).hasClass('active'))){
            $('.nav-option.active').removeClass("active");
            $(this).addClass('active');
        }
        localStorage.navstate = $('#nav-container').html();
        localStorage.pathname = $(this).find('a').attr('href');
    });
};

HeaderManager.prototype.navDropdownOptionClick = function () {
    this.navDropdownOption.click(function(e){
        $(".active").removeClass("active");
        $(this).addClass('active');
        $(this).closest('.nav-option').addClass('active');
        localStorage.navstate = $('#nav-container').html();
        localStorage.pathname = $(this).find('a').attr('href');
        e.stopPropagation();
    });
};


function htmlbodyHeightUpdate(){
    var height3 = $( window ).height();
    var height1 = $('.nav').height()+50;
    height2 = $('.main').height();
    if(height2 > height3){
        $('html').height(Math.max(height1,height3,height2)+10);
        $('body').height(Math.max(height1,height3,height2)+10);
    }
    else
    {
        $('html').height(Math.max(height1,height3,height2));
        $('body').height(Math.max(height1,height3,height2));
    }

}

$(document).ready(function () {
    if(self !== top){
        //$('#nav-container').remove();
        $('#main-container').removeClass('expanded collapsed').addClass('iframe');
        $('nav').removeClass('expanded collapsed').addClass('iframe');
    } else {
        if((location.pathname == localStorage.pathname || location.pathname + location.search == localStorage.pathname) && localStorage.navstate){
            document.getElementById('nav-container').innerHTML = localStorage.navstate;
        } else {
            localStorage.navstate = null;
            localStorage.pathname = null;
        }
        if($('nav').hasClass('collapsed')){
            $('#main-container').removeClass('expanded').addClass('collapsed');
            $('.bold-header-text').addClass('bold-header-text-collapsed');
        }

        $('#nav-container').removeClass("hide");

        var element = $('a[href="' + location.pathname + '"]');
        if(element.length == 0)
            element = $('a[href="' + location.pathname + location.search + '"]');
        var nav_option = element.closest('.nav-option');
        if(!nav_option.hasClass('open') && !$('nav').hasClass('collapsed')) {
            $('.nav-option.active').removeClass("active");
            $('.nav-dropdown-option.active').removeClass('active');
            $('[aria-expanded=true]').dropdown('toggle');
            nav_option.addClass('active');
            nav_option.find('[data-toggle=dropdown]').dropdown('toggle');
            element.closest('.nav-dropdown-option').addClass('active')
        }


        var selectors = {
            nav: "#nav",
            mainContainer: '#main-container',
            expandBtn: '#expand-btn',
            collapseBtn: '#collapse-btn',
            navOption: ".nav-option",
            navDropdownOption: '.nav-dropdown-option',
            dropdownToggle: '.dropdown-toggle',
            homeButton: '#home-button'
        };

        headerManager = new HeaderManager(selectors);
        headerManager.init();

        $(document).on('click', 'body', function (e) {
            e.stopPropagation();
        });
    }
});