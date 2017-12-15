function Get-AccountStatus{
    param(
        $ResponseVersion,
        $RequesterID,
        $RequestID,
        $AccountID,
        $PassPhrase
    )

    $xmlstring = @"
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetAccountStatus xmlns="www.envmgr.com/LabelService">
      <AccountStatusRequest ResponseVersion="$ResponseVersion">
        <RequesterID>$RequesterID</RequesterID>
        <RequestID>$RequestID</RequestID>
        <CertifiedIntermediary>
          <AccountID>$AccountID</AccountID>
          <PassPhrase>$PassPhrase</PassPhrase>
        </CertifiedIntermediary>
      </AccountStatusRequest>
    </GetAccountStatus>
  </soap:Body>
</soap:Envelope>
"@
    $Response = Invoke-EndiciaAPIFunction -XMLString $xmlstring -SOAPActionName GetAccountStatus
    $Response.GetAccountStatusResponse.AccountStatusResponse
}

function Get-ChallengeQuestion{
    param(
        $RequesterID,
        $RequestID,
        $AccountID,
        $EMail
    )

    $xmlstring = @"
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetChallengeQuestion xmlns="www.envmgr.com/LabelService">
      <ChallengeQuestionRequest>
        <RequesterID>$RequesterID</RequesterID>
        <RequestID>$RequestID</RequestID>
        <AccountID>$AccountID</AccountID>
        <EMail>$EMail</EMail>
      </ChallengeQuestionRequest>
    </GetChallengeQuestion>
  </soap:Body>
</soap:Envelope>
"@    
    $Response = Invoke-EndiciaAPIFunction -XMLString $xmlstring -SOAPActionName GetChallengeQuestion
    $Response.GetChallengeQuestionResponse.ChallengeQuestionResponse.Question
}

function Reset-SuspendedAccountRequestXML{
    param(
        $RequesterID,
        $RequestID,
        $AccountID,
        $ChallengeAnswer,
        $NewPassPhrase
    )
$xmlstring = @"
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <ResetSuspendedAccount xmlns="www.envmgr.com/LabelService">
      <ResetSuspendedAccountRequest>
        <RequesterID>$RequesterID</RequesterID>
        <RequestID>$RequestID</RequestID>
        <AccountID>$AccountID</AccountID>
        <ChallengeAnswer>$ChallengeAnswer</ChallengeAnswer>
        <NewPassPhrase>$NewPassPhrase</NewPassPhrase>
      </ResetSuspendedAccountRequest>
    </ResetSuspendedAccount>
  </soap:Body>
</soap:Envelope>
"@
    $Response = Invoke-EndiciaAPIFunction -XMLString $xmlstring -SOAPActionName ResetSuspendedAccount
    $Response.ResetSuspendedAccountResponse.ResetSuspendedAccountRequestResponse
}

function Invoke-EndiciaAPIFunction {
    param (
        $XMLString,
        $SOAPActionName
    )

    $Response = Invoke-WebRequest -Uri https://labelserver.endicia.com/LabelService/EwsLabelService.asmx -Method Post -ContentType "text/xml; charset=utf-8" -Body $xmlstring -Headers @{SOAPAction = "www.envmgr.com/LabelService/$SOAPActionName"}
    $ResponseXML = [xml]$Response.Content
    $ResponseXML.Envelope.Body
}