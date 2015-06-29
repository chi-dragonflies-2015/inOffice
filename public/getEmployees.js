var employeesUrl = "/user_groups/5/get_employees";
var employeeArray = null;
var $employeeList = $("#employeeList");
var outputHTML = "<div class='no-results'>No Employees Found!</div>";

//MINER--where "build()" is the appropriate callback
function getEmployees(callback) {
    
    /* CAN BE AN AJAX "GET" REQUEST -- w/ `updateState` as the event handler */
    $.getJSON(employeesUrl, function(data) {
	if(_.isFunction(callback))
	    callback(data);
    });
};

//EVENT HANDLER
$(document).ready(function(){
    $("#employeeList").on("click", "#1", updateState);
});

function updateState() {
    // alert("taget acquired!");
    event.preventDefault();
    $button = $(event.target);
    $employee = $button.parent();
    console.log($button[0]);
    console.log($button.parent()[0]);

    $.ajax({
        type: "POST",
        url: "/users/1/change_state",
        success: function() {
            if ($employee.attr("class") == "in") {
                // alert("class is 'in'");
                $employee.attr("class","out");
                // console.log($employee.attr("data-state","false"));
            } else {
                $employee.attr("class","in");
                // console.log($employee.attr("data-state","true"));
            }
        }
    });
};


//ARCHITECT--depends on blueprint (template)
function build(employees) {
    setEmployees(employees);
};

    /* ENSURES THAT DATA IS JSON ARRAY -- may be replaceable with server-side functionality... */
	function setEmployees(employees) {
	    if(_.isArray(employees)) {
	        if(_.isEmpty(employees)) {
		        $employeeList.html("<div class='error no-employees'>ERROR! No Employees Found!</div>");
		    } else {
		        employeeArray = employees; //--SUCCESS CASE------------------->>>
                console.log(employeeArray);
            }
	    } else {
		    $employeeList.html("<div class='error not-array'>ERROR! Imported JSON Object Must be an Array</div>");
        }
	};

//BUNKER
$(function() { 
    getEmployees(build); //where "build" is within the global namespace
});
