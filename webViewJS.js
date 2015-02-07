document.getElementsByClassName('site-header')[0].style.display='none';

if(document.getElementsByClassName('archive-description')[0]){
    console.log('non post page');
}else {
    document.getElementsByClassName('content')[0].style.marginTop = '-0px';
}

