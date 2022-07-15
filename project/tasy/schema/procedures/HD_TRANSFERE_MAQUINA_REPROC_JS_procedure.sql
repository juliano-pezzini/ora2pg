-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_transfere_maquina_reproc_js ( nr_sequencia_p bigint, nr_seq_unid_origem_p bigint, nr_seq_unid_destino_p bigint, nr_seq_ponto_dialise_p bigint, dt_transferencia_p timestamp, nm_usuario_p text, ie_opcao_p text, ds_erro_p INOUT text, ds_observacao_p text) AS $body$
DECLARE

ds_erro_w	varchar(255);					
ie_param_205_w	varchar(1);

BEGIN
ie_param_205_w := obter_param_usuario(7009, 205, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_param_205_w);
 
if (ie_opcao_p = 'M') then 
	ds_erro_w := HD_Transfere_Maquina(nr_sequencia_p, nr_seq_unid_origem_p, nr_seq_unid_destino_p, nr_seq_ponto_dialise_p, dt_transferencia_p, nm_usuario_p, ds_observacao_p, ds_erro_w);		
	 
	ds_erro_p := ds_erro_w;
	 
	if (ie_param_205_w = 'S') and (ds_erro_w = '') then 
		CALL hd_transferir_equip_maquina(nr_sequencia_p,nr_seq_ponto_dialise_p,nm_usuario_p);
	end if;
		 
 
elsif (ie_opcao_p = 'R') then 
	ds_erro_w := HD_Transfere_Reproc(nr_sequencia_p, nr_seq_unid_origem_p, nr_seq_unid_destino_p, dt_transferencia_p, nm_usuario_p, ds_erro_w);
 
	ds_erro_p := ds_erro_w;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_transfere_maquina_reproc_js ( nr_sequencia_p bigint, nr_seq_unid_origem_p bigint, nr_seq_unid_destino_p bigint, nr_seq_ponto_dialise_p bigint, dt_transferencia_p timestamp, nm_usuario_p text, ie_opcao_p text, ds_erro_p INOUT text, ds_observacao_p text) FROM PUBLIC;

