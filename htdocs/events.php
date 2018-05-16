<?php
require_once('inc/garage.class.php');

$garage = new Garage(true, true, true, false);
?>
<!DOCTYPE html>
<html lang='en'>
  <head>
    <title>Garage - Events</title>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
    <link rel='stylesheet' href='//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css' integrity='sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm' crossorigin='anonymous'>
    <link rel='stylesheet' href='//bootswatch.com/4/darkly/bootstrap.min.css'>
    <link rel='stylesheet' href='//use.fontawesome.com/releases/v5.0.12/css/all.css' integrity='sha384-G0fIWCsCzJIMAVNQPfjH08cyYaUtMwjJwqiRKxxE/rx96Uroj1BtIQ6MLJuheaO9' crossorigin='anonymous'>
  </head>
  <body>
    <div class='container'>
      <table class='table table-striped table-hover table-sm mt-3'>
        <thead>
          <tr>
            <th>Date</th>
            <th>User Name</th>
            <th>Action</th>
            <th>Message</th>
            <th>Remote Addr</th>
          </tr>
        </thead>
        <tbody>
<?php
foreach ($garage->getEvents() as $event) {
  $date = date('m/d/Y, h:i A', $event['date']);
  $user_name = !empty($event['last_name']) ? sprintf('%2$s, %1$s', $event['first_name'], $event['last_name']) : $event['first_name'];
  $remote_addr = !empty($event['remote_addr']) ? long2ip($event['remote_addr']) : null;

  echo "          <tr>" . PHP_EOL;
  echo "            <td>{$date}</td>" . PHP_EOL;
  echo "            <td>{$user_name}</td>" . PHP_EOL;
  echo "            <td>{$event['action']}</td>" . PHP_EOL;
  echo "            <td>{$event['message']}</td>" . PHP_EOL;
  echo "            <td>{$remote_addr}</td>" . PHP_EOL;
  echo "          </tr>" . PHP_EOL;
}
?>
        </tbody>
      </table>
    </div>
    <script src='//code.jquery.com/jquery-3.2.1.min.js' integrity='sha384-xBuQ/xzmlsLoJpyjoggmTEz8OWUFM0/RC5BsqQBDX2v5cMvDHcMakNTNrHIW2I5f' crossorigin='anonymous'></script>
    <script src='//cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js' integrity='sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q' crossorigin='anonymous'></script>
    <script src='//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js' integrity='sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl' crossorigin='anonymous'></script>
  </body>
</html>
