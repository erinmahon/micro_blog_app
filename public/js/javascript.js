$(document).ready(function(){
	$('#unfollow').on('click',function(){
		$(this).removeClass('show').addClass('hide');
		$('#follow').removeClass('hide').addClass('show');
	});

	$('#follow').on('click',function(){
		$(this).removeClass('show').addClass('hide');
		$('#unfollow').removeClass('hide').addClass('show');
	});
});