//
//  PhotonTrajectoryGenerator.swift
//  RenderPipeline
//
//  Created by robertvict on 29/05/23.
//

import Foundation

struct RNGWithSeed : RandomNumberGenerator {
    init(seed: Int) {
        srand48(seed)
    }
    
    func next() -> UInt64 {
        return UInt64(drand48() * Double(UInt64.max));
    }
}

let seed = 101
var rng = RNGWithSeed(seed: seed)

/*
 Generate a trajactory for a photon
 */
func GenerateTrajectory(_ trajectory_size: Int) -> [SIMD3<Float>] {
    let photon_trajectory: [SIMD3<Float>] = (0..<trajectory_size).map { _ in SIMD3<Float>.random(in: 1...20, using: &rng) }
    return photon_trajectory
}

/*
 Generate list of photons, all of which have the same trajectory size
 */
func GeneratePhotons(_ photon_num: Int, _ trajectory_size: Int, _ photons: inout[[SIMD3<Float>]]) {
    photons = (0..<photon_num).map {_ in GenerateTrajectory(trajectory_size)}
}

func WriteToFile(_ photons: inout[[SIMD3<Float>]]) {
    //convert to string
    let photons_string = photons.reduce("",
        {prev_traj, curr_traj in
        prev_traj + curr_traj.reduce("", {
                prev, curr in
                prev + "\(curr.x) \(curr.y) \(curr.z), "
        }).dropLast().dropLast() + "\n" //two droplast to get rid of the ", "
    })
    //write to file PhotonData.txt at directory where program is run
    let filepath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath+"/PhotonData.txt")
    print("Writing to \(filepath)")
    do{
        try photons_string.write(to: filepath, atomically: true, encoding: .ascii)
    } catch {
        assertionFailure("Failed to write to URL: \(filepath)")
    }
}

var photons = [[SIMD3<Float>]]()
GeneratePhotons(2, 2, &photons)
WriteToFile(&photons)
