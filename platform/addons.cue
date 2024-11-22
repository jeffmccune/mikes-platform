package holos
import ("encoding/json")


Addons: {
  "cilium": {
    path: "addons/cni/cilium"
    parameters: {
      addonParam: "test"
    }
    selector: {
      "cluster_cni": "cilium"
    }
  }
}

// === Render ===

for fleetName, fleet in Fleets {
  for clusterName, cluster in fleet.clusters{
    for addonName, addon in Addons {
      let _params = {
        "fleet": fleet.parameters
        "cluster": cluster.parameters
      } & addon.parameters

      Platform: Components: {
        "\(fleetName).\(clusterName).addons.\(addonName)": {
          name: "\(fleetName).\(clusterName).addons.\(addonName)"
          path: addon.path
          writeTo?: fleet.componentWriteTo
          parameters: holos_params: json.Marshal(_params)
        }
      }
    }
  }
}
