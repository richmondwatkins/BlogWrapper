(function () {
    document.getElementsByClassName('site-header')[0].style.display='none';
    
    if(document.getElementsByClassName('archive-description')[0]){
        console.log('non post page');
    }else {
        document.getElementsByClassName('content')[0].style.marginTop = '-0px';
    }
    
    
    if(document.getElementsByClassName('comment-respond')[0]){
        document.getElementsByClassName('content')[0].style.marginTop = '-90px';
    }
    
    document.getElementById('wdpu-text').style.display = 'none';

 })();