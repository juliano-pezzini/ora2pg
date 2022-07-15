-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescr_mat_compl (nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ie_item_disp_gerado_p text, ds_horarios_enf_p text default null, nr_seq_agente_anest_p cirurgia_agente_anestesico.nr_sequencia%type default null) AS $body$
DECLARE

nr_cont_w  numeric(2,0);

BEGIN

if (coalesce(nr_prescricao_p,0) > 0) and (coalesce(nr_sequencia_p,0) > 0) then
	
  select  count(*)
  into STRICT    nr_cont_w
  from    prescr_material_compl
  where   nr_sequencia = nr_sequencia_p
  and     nr_prescricao = nr_prescricao_p;

  if (nr_cont_w = 0) then
    begin
    insert into prescr_material_compl(
      nr_sequencia,
      nr_prescricao,
      nm_usuario_nrec,
      dt_atualizacao_nrec,
      nm_usuario,
      dt_atualizacao,
      ie_item_disp_gerado,
      ds_horario_enf,
	  nr_seq_agente_anestesico)
    values (
      nr_sequencia_p,
      nr_prescricao_p,
      coalesce(nm_usuario_p,wheb_usuario_pck.get_nm_usuario),
      clock_timestamp(),
      coalesce(nm_usuario_p,wheb_usuario_pck.get_nm_usuario),
      clock_timestamp(),
      ie_item_disp_gerado_p,
      ds_horarios_enf_p,
	  nr_seq_agente_anest_p);

    exception when others then
		CALL gravar_log_tasy(cd_log_p => 10007, 
						ds_log_p => substr('Exception gerar_prescr_mat_compl - Linha:'||$$plsql_line||pls_util_pck.enter_w
										|| ' nr_prescricao_p:'|| nr_prescricao_p||pls_util_pck.enter_w
										|| ' nm_usuario_p:'||nm_usuario_p||pls_util_pck.enter_w
										|| ' nr_sequencia_p:'|| nr_sequencia_p||pls_util_pck.enter_w
										|| ' ie_item_disp_gerado_p:'||ie_item_disp_gerado_p||pls_util_pck.enter_w
										|| ' ds_horarios_enf_p:'||ds_horarios_enf_p||pls_util_pck.enter_w
										|| ' Erro:'||substr(sqlerrm,1,100),1,2000),
						nm_usuario_p => nm_usuario_p);
    end;	

  end if;  	

end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescr_mat_compl (nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ie_item_disp_gerado_p text, ds_horarios_enf_p text default null, nr_seq_agente_anest_p cirurgia_agente_anestesico.nr_sequencia%type default null) FROM PUBLIC;

