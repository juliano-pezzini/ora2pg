-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pcs_setar_ie_selecionado ( nr_seq_reclassif_p bigint default 0, nr_seq_registro_p bigint default 0, ie_opcao_p text DEFAULT NULL, nm_tabela_p text DEFAULT NULL, nm_usuario_p text DEFAULT NULL) AS $body$
BEGIN

if (ie_opcao_p = 'N') and (nm_tabela_p = 'PCS_PARECER') and (nr_seq_reclassif_p > 0) then
	update	pcs_parecer
	set		ie_selecionado = 'N'
	where	nr_seq_reclassif = nr_seq_reclassif_p;
elsif (ie_opcao_p = 'N') and (nm_tabela_p = 'PCS_PARECER') and (nr_seq_registro_p > 0) then
	update	pcs_parecer
	set		ie_selecionado = 'N'
	where	nr_seq_registro_pcs = nr_seq_registro_p;
elsif (ie_opcao_p = 'N') and (nm_tabela_p = 'PCS_REGRA_ATIVIDADES') then
	update	pcs_regra_atividades
	set		ie_selecionado = 'N';
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pcs_setar_ie_selecionado ( nr_seq_reclassif_p bigint default 0, nr_seq_registro_p bigint default 0, ie_opcao_p text DEFAULT NULL, nm_tabela_p text DEFAULT NULL, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;

