---
name: pr-comments
description: Fix, reply to, and resolve every open PR review thread
disable-model-invocation: true
---
1. List unresolved review threads (including Copilot's). `gh pr view` does not return threads; use GraphQL:
   ```sh
   gh api graphql -F owner='{owner}' -F repo='{repo}' -F pr=<number> -f query='
     query($owner:String!,$repo:String!,$pr:Int!){repository(owner:$owner,name:$repo){pullRequest(number:$pr){
       reviewThreads(first:100){nodes{id isResolved path line comments(first:20){nodes{author{login} body}}}}}}}' \
     --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved|not)'
   ```
2. For each thread, make the code change.
3. Run the affected tests and the lint/type check. If migrations or scripts changed, run `/verify-branch`.
4. Commit with a message that references the thread topics, then push.
5. Reply on each thread, then resolve the fixed ones:
   ```sh
   gh api graphql -F id=<thread id> -F body='<reply>' -f query='mutation($id:ID!,$body:String!){addPullRequestReviewThreadReply(input:{pullRequestReviewThreadId:$id,body:$body}){comment{url}}}'
   gh api graphql -F id=<thread id> -f query='mutation($id:ID!){resolveReviewThread(input:{threadId:$id}){thread{isResolved}}}'
   ```
   Done when every thread is either replied to with what changed plus the commit SHA and resolved, or replied to with the locked decision it conflicts with and left open.
6. If scope changed, update the PR description and comment on the linked Jira ticket (via the Atlassian MCP) with what changed.
7. Report: threads fixed / deferred (with decision ID) / tests run.
