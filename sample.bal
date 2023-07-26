import ballerina/http;
import ballerina/log;
import ballerinax/trigger.github;
import ballerinax/slack;

// Github configuration parameters
configurable github:ListenerConfig gitHubListenerConfig = ?;

// Slack configuration parameters
configurable string slackAuthToken = ?;
configurable string slackChannelName = ?;

listener http:Listener httpListener = new(8090);
listener github:Listener gitHubListener = new (gitHubListenerConfig, httpListener);

@display { label: "GitHub New Pull request to Slack Channel Message" }
service github:PullRequestService on gitHubListener {
    remote function onOpened(github:PullRequestEvent payload) returns error? {

        string pullRequestID = payload.pull_request.number;
        string reqBody = payload.pull_request.body ?: "";
        string reqUrl = payload.pull_request.url;
        string title = payload.pull_request.title;

        string message = "There is a new pull request in GitHub ! \n <" + reqUrl+ ">\n";


        slack:Client slackClient = check new ({auth: {token: slackAuthToken}});
        string response = check slackClient->postMessage({
            channelName: slackChannelName,
            text: message
        });
        log:printInfo("Message sent successfully " + response.toString());
    }
    remote function onClosed(github:PullRequestEvent payload) returns error? {
        return;
    }
    remote function onReopened(github:PullRequestEvent payload) returns error? {
        return;
    }
    remote function onAssigned(github:PullRequestEvent payload) returns error? {
        return;
    }
    remote function onUnassigned(github:PullRequestEvent payload) returns error? {
        return;
    }
    remote function onReviewRequested(github:PullRequestEvent payload) returns error? {
        return;
    }
    remote function onReviewRequestRemoved(github:PullRequestEvent payload) returns error? {
        return;
    }
    remote function onLabeled(github:PullRequestEvent payload) returns error? {
        return;
    }
    remote function onUnlabeled(github:PullRequestEvent payload) returns error? {
        return;
    }
    remote function onEdited(github:PullRequestEvent payload) returns error? {
        return;
    }
}

service /ignore on httpListener {}
