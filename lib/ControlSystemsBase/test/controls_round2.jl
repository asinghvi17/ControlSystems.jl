using Test, ControlSystemsBase, LinearAlgebra
@testset "prepared numeric dispatch" begin
    P=ss([0. 1.;-1. -.4],reshape([0.,2.],2,1),[1. 0.],zeros(1,1))
    for method in (:zoh,:foh,:tustin)
        a=c2d(P,.02,method);b=c2d(P,.02,Val(method))
        @test a.A ≈ b.A
        @test a.B ≈ b.B
    end
    w=collect(10.0.^range(-2,3;length=51))
    for full in (false,true),allMargins in (false,true),balance in (false,true)
        m=margin(P,w;full,allMargins,balance)
        @test hasproperty(m,:fullPhase)==full
        @test size(m.pm)==(1,1)
    end
    @test margin(P).pm ≈ margin(P[1,1]).pm
end
