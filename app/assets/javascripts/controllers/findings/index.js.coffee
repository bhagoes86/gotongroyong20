problemApp = angular.module('problemApp')
problemApp.controller('IndexFindingController', ['Findings', 'FindingVotes',
  (Findings, FindingVotes) ->
    updateFindingVote = (finding, data) ->
      finding.my_vote_status = data.my_vote_status
      finding.up_vote = data.up_vote
      finding.down_vote = data.down_vote
  
    vm = this
    vm.voteImgStyle = {
        'width': '20px',
        'height': '25px'
    } 
    vm.newFinding = new Findings()
    vm.newReply = new Findings()
    
    loadFindings = () ->
      vm.findings = Findings.query({problem_id: gon.problem_id})    
    
    unvote = (finding) ->
      v = new FindingVotes({type: 'unvote'})
      v.$save({problem_id: gon.problem_id, finding_id: finding.id},
        (data, header) -> updateFindingVote(finding, data)
        (data ,header) ->
          if(data.status = 401)
            alert("You are not authorized to vote this item")
          else
            alert("You need to log in to vote"))
      
    vm.vote_up = (finding) ->
      if(finding.my_vote_status == 'up')
        unvote(finding)
      else
        v = new FindingVotes({type: 'up'})
        v.$save({problem_id: gon.problem_id, finding_id: finding.id},
          (data, header) -> updateFindingVote(finding, data)
          (data ,header) ->
            if(data.status = 401)
              alert("You are not authorized to vote this item")
            else
              alert("You need to log in to vote"))
          
    vm.vote_down = (finding) ->
      if(finding.my_vote_status == 'down')
        unvote(finding)
      else
        v = new FindingVotes({type: 'down'})
        v.$save({problem_id: gon.problem_id, finding_id: finding.id},
          (data, header) -> updateFindingVote(finding, data)
          (data ,header) ->
            if(data.status = 401)
              alert("You are not authorized to vote this item")
            else
              alert("You need to log in to vote"))
    
    vm.createFinding = (finding) ->
      finding.$save({problem_id: gon.problem_id},
        (data, header) -> 
          item = new Findings(data)
          vm.findings.push(item)
          vm.newFinding = new Findings()
        (data ,header) -> alert("You need to log in to write finding"))
    
    vm.createReply = (parent_finding, reply) ->
      reply.parent_id = parent_finding.id
      reply.$save({problem_id: gon.problem_id},
        (data, header) -> loadFindings()
        (data ,header) -> alert("You need to log in to write finding"))

    vm.delete = (finding) ->
      if confirm("Do you really want to delete?") == true
        finding.$delete({problem_id: gon.problem_id, finding_id: finding.id},
          (data,header) -> loadFindings()
          (data,header) -> alert("You're not authorized to delete this item"))

    loadFindings()
    
    return vm
])
