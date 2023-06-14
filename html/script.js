$(function() {
	window.addEventListener('message', function(event) {
		if (event.data.action == 'show') {
			let components = event.data.components;
			let weapon = event.data.weapon;
			
			$('#attachments').html('');
			
			for (let i = 0; i < components.length; i++) {
				if (components[i].used) {
					$('#attachments').append(`
						<tr id="` + components[i].value + `">
							<td><img class="` + components[i].value + ` equiped" src="./images/` + components[i].value + `.png"/></td>
							<td><button onclick="RemoveComponent(\'` + components[i].value + `\', \'` + weapon + `\')" id="equiped"><i class="fas fa-badge-check"></i> Equiped</button></td>
						</tr>`);
				}
				else {
					$('#attachments').append(`
						<tr id="` + components[i].value + `">
							<td><img class="` + components[i].value + ` not-equiped" src="./images/` + components[i].value + `.png"/></td>
							<td><button onclick="AddComponent(\'` + components[i].value + `\', \'` + weapon + `\')" id="not-equiped"><i class="fal fa-times-square"></i> Not Equiped</button></td>
						</tr>`);
				}
			}
			
			$('#attachments').append(`
			<tr id="equipAll">
				<td><img class="equiped" src="./images/ar_part.png"/></td>
				<td><button onclick="addAllComponents(\'` + weapon + `\')" id="equiped"><i class="fas fa-badge-check"></i> Equip All Attachments</button></td>
			</tr>`);
			
			$('#attachments').append(`
			<tr id="removeAll">
				<td><img class="not-equiped" src="./images/ar_part.png"/></td>
				<td><button onclick="removeAllComponents(\'` + weapon + `\')" id="not-equiped"><i class="fal fa-times-square"></i> Remove All Attachments</button></td>
			</tr>`);
			
			$('#wrap').show();
		}
		else if (event.data.action == 'remove') {
			let item = event.data.item;
			let weapon = event.data.weapon;
			
			$(`#`+ item).html(`
				<td><img class="` + item + ` not-equiped" src="./images/` + item + `.png"/></td>
				<td><button onclick="AddComponent(\'` + item + `\', \'` + weapon + `\')" id="not-equiped"><i class="fal fa-times-square"></i> Not Equiped</button></td>`
			);
		}
		else if (event.data.action == 'add') {
			let item = event.data.item;
			let weapon = event.data.weapon;
			
			$(`#`+ item).html(`
				<td><img class="` + item + ` equiped" src="./images/` + item + `.png"/></td>
				<td><button onclick="RemoveComponent(\'` + item + `\', \'` + weapon + `\')" id="equiped"><i class="fas fa-badge-check"></i> Equiped</button></td>`
			);
		}
	});
	
	document.onkeyup = function(event) {
		if (event.key == 'Escape') {
			$('#wrap').hide();
			$.post('https://esx_attatchments/quit', JSON.stringify({}));
		}
	};
});

addAllComponents = function(weapon) {
	$.post('https://esx_attatchments/addAllComponents', JSON.stringify({weapon: weapon}));
}

removeAllComponents = function(weapon) {
	$.post('https://esx_attatchments/removeAllComponents', JSON.stringify({weapon: weapon}));
}

function RemoveComponent(item, weapon) {
	$.post('https://esx_attatchments/remove', JSON.stringify({item: item, weapon: weapon}));
}

function AddComponent(item, weapon) {
	$.post('https://esx_attatchments/add', JSON.stringify({item: item, weapon: weapon}));
}