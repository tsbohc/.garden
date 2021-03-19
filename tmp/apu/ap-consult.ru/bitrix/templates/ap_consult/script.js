$(function(){
	$("body").on("click", '.js-show-pop-up2', function(e){
		e.preventDefault();
		let target = $(this).data('target');
		console.log(target)
		$(target + ".js-pop-up").addClass("active"), window.scrollTo({
			top     : 0,
			behavior: "smooth"
		})
	})

	$('body').on('submit', '[action="/ajax.php"]', function(e){
		e.preventDefault()
		let form = $(this)
		$(this).ajaxSubmit({
			resetForm: true,
			success: function(data){
				data = JSON.parse(data)
				if(data.success)
					{
						form.prepend('<p class="mb-3 p-1 border rounded-0">'+data.message+'</p>')
						//form.reset()
					}
			}
		})
	})
})