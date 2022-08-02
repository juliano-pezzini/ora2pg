-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_cart_interface ( nr_seq_lote_p bigint, cd_interface_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

/*Ativia*/

if (cd_interface_p = 2155) then
	CALL pls_gerar_cartao_ativia(nr_seq_lote_p,cd_estabelecimento_p,nm_usuario_p);
/*Seisa*/

elsif (cd_interface_p = 2180) then
	CALL pls_gerar_cartao_seisa(nr_seq_lote_p,cd_estabelecimento_p,nm_usuario_p);
/*Unimed Blumenau*/

elsif (cd_interface_p in (2185, 2702, 2722)) then -- 2702 = PTU 5.1 / 2722 = PTU 5.2
	CALL pls_gerar_cartao_unimed_blu(nr_seq_lote_p,cd_interface_p,cd_estabelecimento_p,nm_usuario_p);
/*Unimed Litoral*/

elsif (cd_interface_p in (2205, 2683, 2704)) then -- 2683 = PTU 5.0 / 2704 = PTU 5.1
	CALL pls_gerar_cart_unimed_litoral(nr_seq_lote_p,cd_interface_p,cd_estabelecimento_p,nm_usuario_p);
/*Unimed Ituverava*/

elsif (cd_interface_p = 2237) then
	CALL pls_gerar_cart_unimed_ituverav(nr_seq_lote_p,cd_estabelecimento_p,nm_usuario_p);
/*Unimed Sao Jose Rio Preto*/

elsif (cd_interface_p in (2243, 2720)) then -- 2720 = PTU 5.1
	CALL pls_gerar_cart_unimed_sjrp(nr_seq_lote_p,cd_interface_p,null,null,cd_estabelecimento_p,nm_usuario_p);
/*Unimed Lencois Paulista*/

elsif (cd_interface_p in (2433, 2682, 2723)) then -- 2682 = PTU 5.0 / 2723 = PTU 5.1
	pls_gerar_cart_unimed_lencois(nr_seq_lote_p,cd_interface_p,cd_estabelecimento_p,nm_usuario_p);	
/*Unimed Maringa*/

elsif (cd_interface_p in (2607, 2662, 2700)) then -- 2662  PTU 5.0 / 2700 = PTU 5.1
	CALL pls_gerar_cart_unimed_maringa(nr_seq_lote_p,cd_interface_p,cd_estabelecimento_p,nm_usuario_p);
/*Unimed Sao Carlos*/

elsif (cd_interface_p in (2622, 2674)) then -- 2674 = PTU 5.1
	CALL pls_gerar_cart_unim_sao_carlos(nr_seq_lote_p,cd_estabelecimento_p,nm_usuario_p);
/*Benecamp*/

elsif (cd_interface_p = 2523) then
	CALL pls_gerar_cartao_benecamp(nr_seq_lote_p,cd_estabelecimento_p,nm_usuario_p);
/*Santamalia*/

elsif (cd_interface_p = 2553) then
	CALL pls_gerar_cartao_santamalia(nr_seq_lote_p,cd_estabelecimento_p,nm_usuario_p);
/*Marcio Cunha*/

elsif (cd_interface_p = 2603) then
	CALL pls_gerar_cartao_marciocunha(nr_seq_lote_p,cd_estabelecimento_p,nm_usuario_p);
/*Filosanitas LTDA*/

elsif (cd_interface_p = 2631) then
	CALL pls_gerar_cartao_filosanitas(nr_seq_lote_p,cd_estabelecimento_p,nm_usuario_p);
/*Hospital  R. Franca*/

elsif (cd_interface_p in (2707, 2708)) then -- 2708 = Odonto
	CALL pls_gerar_cart_hr_franca(nr_seq_lote_p,cd_interface_p,cd_estabelecimento_p,nm_usuario_p);
/* Plano de Saude Ases Ltda */

elsif (cd_interface_p = 2778) then
	CALL pls_gerar_cartao_ases(nr_seq_lote_p,cd_estabelecimento_p,nm_usuario_p);
/* Irmandade Santa Casa de Misericordia de Limeira*/

elsif (cd_interface_p	= 2848) then
	CALL pls_gerar_cartao_iscml(nr_seq_lote_p, cd_estabelecimento_p, nm_usuario_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_cart_interface ( nr_seq_lote_p bigint, cd_interface_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

