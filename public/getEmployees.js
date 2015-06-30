var employeeArray = null;
var $employeeList = $("#employeeList");
var outputHTML = "<div class='no-results'>No Employees Found!</div>";


//EVENT HANDLER
$(document).ready(function(){
    $("#employeeList").on("load", getEmployees(build));
    $("#employeeList").on("click", "button", updateState);


    //MINER--where "build()" is the appropriate callback
    function getEmployees(callback) {
        var $employeesUrl = $("#employeeList").attr("route");
        
        /* CAN BE AN AJAX "GET" REQUEST -- w/ `updateState` as the event handler */
        $.getJSON($employeesUrl, function(data) {
        if(_.isFunction(callback))
            callback(data);
        });
    };
});

function updateState() {
    // alert("taget acquired!");
    event.preventDefault();
    $button = $(event.target);
    $employee = $button.parent();
    route = $button.attr("formaction")
    console.log(route);
    // console.log($button[0]);
    // console.log($button.parent()[0]);

    $.ajax({
        type: "POST",
        url: route,
        success: function(response) {
            // console.log(response);
            $employee.attr("class",response)
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

