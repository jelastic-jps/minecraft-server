//@auth
//@req(nodeId, port)

import com.hivext.api.development.Scripting;

var envName = '${env.envName}';

var resp = jelastic.env.control.AddEndpoint(envName, session, nodeId, port, "TCP", "Minecraft Server");
if (resp.result != 0) return resp;

var url = "${env.domain}:" + resp.object.publicPort;

resp = jelastic.env.file.ReplaceInBody(envName, session, "/data/web/index.html", "${ENDPOINT_URL}", url, 1, null, "cp", true, nodeId);
if (resp.result != 0) return resp;

var scripting =  hivext.local.exp.wrapRequest(new Scripting({
    serverUrl : "http://" + window.location.host.replace("app", "appstore") + "/"
}));

return {
    result: 0,
    onAfterReturn : {
        sendEmail : {
            url : url
        }
    }
}
