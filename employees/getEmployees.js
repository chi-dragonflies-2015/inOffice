var employeesUrl = "employees.json";
var employeeArray = null;
var $employeeList = null;
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
function updateState(id) {
    var $employee = $employeeList.find('[data-id=' + id + ']');
    if($employee.data("state")===false)
        setHere($employee);
    else
        setAway($employee);
};

    function setHere($employee) {
        $employee.removeClass("out").addClass("in");
        $employee.data("state",true);
    };

    function setAway($employee) {
        $employee.removeClass("in").addClass("out");
        $employee.data("state",false);
    };


//ARCHITECT--depends on blueprint (template)
function build(employees) {
    setEmployees(employees);
    console.log(employees);

    //store interpolated template
    var outputHTML = _.template($( "script.template" ).html());

    //place template on page
    $( ".template" ).after(outputHTML( employeeArray ));
};

    /* ENSURES THAT DATA IS JSON ARRAY -- may be replaceable with server-side functionality... */
	function setEmployees(employees) {
	    if(_.isArray(employees)) {
	        if(_.isEmpty(employees)) {
		        $employeeList.html("<div class='error no-employees'>ERROR! No Employees Found!</div>");
		    } else {
		        employeeArray = employees; //--SUCCESS CASE------------------->>>
            }
	    } else {
		    $employeeList.html("<div class='error not-array'>ERROR! Imported JSON Object Must be an Array</div>");
        }
	};

//BUNKER
$(function() {
    $employeeList = $('#employeeList');
    getEmployees(build); //where "build" is within the global namespace
});
