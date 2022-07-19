-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gravar_con_fol_bpa_comp ( nr_seq_protocolo_p sus_control_folha_bpa_comp.nr_seq_protocolo%type, dt_mesano_referencia_p sus_control_folha_bpa_comp.dt_mesano_referencia%type, cd_cns_medico_exec_p sus_control_folha_bpa_comp.cd_cns_medico_exec%type , cd_cbo_medico_exec_p sus_control_folha_bpa_comp.cd_cbo_medico_exec%type , nr_folha_bpi_p sus_control_folha_bpa_comp.nr_folha_bpi%type , nr_linha_folha_bpi_p sus_control_folha_bpa_comp.nr_linha_folha_bpi%type, nr_seq_control_folha_w INOUT sus_control_folha_bpa_comp.nr_sequencia%type) AS $body$
DECLARE


nr_sequencia_w   		 sus_control_folha_bpa_comp.nr_sequencia%type;


BEGIN

select	max(coalesce(nr_sequencia,0))
into STRICT	nr_sequencia_w
from	sus_control_folha_bpa_comp
where	trunc(dt_mesano_referencia,'month') = trunc(dt_mesano_referencia_p,'month')
and	cd_cns_medico_exec = cd_cns_medico_exec_p
and	cd_cbo_medico_exec = cd_cbo_medico_exec_p;

if (coalesce(nr_sequencia_w,0) > 0) then
	begin
	update	sus_control_folha_bpa_comp
	set	nr_seq_protocolo = nr_seq_protocolo_p,
		nr_folha_bpi = CASE WHEN coalesce(nr_folha_bpi_p,0)=0 THEN 1  ELSE nr_folha_bpi_p END ,
		nr_linha_folha_bpi = CASE WHEN coalesce(nr_linha_folha_bpi_p,0)=0 THEN 1  ELSE nr_linha_folha_bpi_p END
	where 	nr_sequencia = nr_sequencia_w;
	end;
else
	begin

	select	nextval('sus_control_folha_bpa_comp_seq')
	into STRICT	nr_sequencia_w
	;

	insert into sus_control_folha_bpa_comp(	cd_cbo_medico_exec,
						cd_cns_medico_exec,
						dt_atualizacao,
						dt_mesano_referencia,
						nm_usuario,
						nr_folha_bpi,
						nr_linha_folha_bpi,
						nr_seq_protocolo,
						nr_sequencia)
						values (cd_cbo_medico_exec_p,
						cd_cns_medico_exec_p,
						clock_timestamp(),
						dt_mesano_referencia_p,
						wheb_usuario_pck.get_nm_usuario,
						1,
						1,
						nr_seq_protocolo_p,
						nr_sequencia_w);

	end;
end if;

nr_seq_control_folha_w := nr_sequencia_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gravar_con_fol_bpa_comp ( nr_seq_protocolo_p sus_control_folha_bpa_comp.nr_seq_protocolo%type, dt_mesano_referencia_p sus_control_folha_bpa_comp.dt_mesano_referencia%type, cd_cns_medico_exec_p sus_control_folha_bpa_comp.cd_cns_medico_exec%type , cd_cbo_medico_exec_p sus_control_folha_bpa_comp.cd_cbo_medico_exec%type , nr_folha_bpi_p sus_control_folha_bpa_comp.nr_folha_bpi%type , nr_linha_folha_bpi_p sus_control_folha_bpa_comp.nr_linha_folha_bpi%type, nr_seq_control_folha_w INOUT sus_control_folha_bpa_comp.nr_sequencia%type) FROM PUBLIC;

