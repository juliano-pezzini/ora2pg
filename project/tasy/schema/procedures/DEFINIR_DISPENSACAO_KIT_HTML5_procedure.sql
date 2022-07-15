-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE definir_dispensacao_kit_html5 ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_cpoe_p cpoe_material.nr_sequencia%type, ie_necessita_disp_p prescr_material.ie_regra_disp%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


cd_motivo_baixa_w			prescr_material.cd_motivo_baixa%type;
nr_prescricao_vigente_w		prescr_medica.nr_prescricao%type;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
		a.nr_prescricao
from	prescr_material a
where	a.nr_prescricao >= nr_prescricao_vigente_w
and		a.nr_seq_mat_cpoe = nr_seq_cpoe_p
and		a.ie_agrupador = 1;

BEGIN

if (nr_seq_cpoe_p > 0) then

	nr_prescricao_vigente_w := gpt_obter_prescricao_vigente(nr_seq_cpoe_p, 'M');

	select	max(obter_valor_param_usuario(924, 194, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo))
	into STRICT	cd_motivo_baixa_w
	;

	for r_c01_w in c01
	loop
		begin

		update	prescr_material a
		set		a.ie_necessita_disp_kit = ie_necessita_disp_p
		where	a.nr_prescricao = r_c01_w.nr_prescricao
		and		a.nr_sequencia = r_c01_w.nr_sequencia;

		update	prescr_material a
		set		a.ie_regra_disp = ie_necessita_disp_p,
				a.dt_baixa = CASE WHEN ie_necessita_disp_p='N' THEN  clock_timestamp()  ELSE null END ,
				a.cd_motivo_baixa = CASE WHEN ie_necessita_disp_p='N' THEN  cd_motivo_baixa_w  ELSE 0 END
		where	a.nr_prescricao = r_c01_w.nr_prescricao
		and		a.nr_seq_kit = r_c01_w.nr_sequencia;

		end;
	end loop;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE definir_dispensacao_kit_html5 ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_cpoe_p cpoe_material.nr_sequencia%type, ie_necessita_disp_p prescr_material.ie_regra_disp%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

