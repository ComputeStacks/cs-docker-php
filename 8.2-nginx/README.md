# PHP-FPM 8.2

## SMTP Configuration

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Value</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>SMTP_SERVER</td>
      <td>IP or Hostname of the SMTP server</td>
      <td><pre>null</pre></td>
    </tr>
    <tr>
      <td>SMTP_PASSWORD</td>
      <td>SMTP Password</td>
      <td><pre>null</pre></td>
    </tr>
    <tr>
      <td>SMTP_USERNAME</td>
      <td>Username</td>
      <td><pre>null</pre></td>
    </tr>
    <tr>
      <td>SMTP_PORT</td>
      <td>smtp port</td>
      <td><pre>null</pre></td>
    </tr>
    <tr>
      <td>PM_STREAM</td>
      <td>Postmark Message Stream ID</td>
      <td><pre>null</pre></td>
    </tr>
  </tbody>
</table>

## Monarx Support

This image includes support for [Monarx](https://www.monarx.com). By default it's _**disabled**_ unless you include the following environmental variables at boot (_can be enabled after initial install_):

* `MONARX_ID`
* `MONARX_SECRET`
