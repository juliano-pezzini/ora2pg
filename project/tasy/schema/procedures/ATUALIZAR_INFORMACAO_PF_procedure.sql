-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_informacao_pf ( ie_periodo_p text, dt_periodo_p timestamp, nm_usuario_p text) AS $body$
DECLARE


/* ie_periodo_p	-> H-Horário / D-Diário / M-Mensal */

dt_inicial_w	timestamp;
dt_final_w	timestamp;

cd_pf_w		varchar(20);
nr_prescricao_w	bigint;
nr_seq_result_w	bigint;
nr_Seq_prescr_w	bigint;
nr_seq_perda_ganho_w  bigint;

nr_seq_exame_w	bigint;
ds_resultado_w	varchar(255);


c01 CURSOR FOR
	SELECT	z.cd_pessoa_fisica,
		x.nr_prescricao,
		y.nr_seq_resultado,
		y.nr_seq_prescr
	from 	prescr_medica z,
		exame_lab_resultado x,
		exame_lab_result_item y
	where z.nr_prescricao = x.nr_prescricao
	  and y.nr_seq_resultado = x.nr_seq_resultado
	  and y.dt_aprovacao between dt_inicial_w and dt_final_w
	order by 2, 3;

c02 CURSOR FOR
	SELECT	nr_seq_exame,
		substr(ds_resultado || qt_resultado || pr_resultado,1,255)
	from exame_lab_result_item y
	where nr_seq_resultado	= nr_seq_result_w
	  and nr_seq_prescr	= nr_seq_prescr_w;

C03 CURSOR FOR
	SELECT  d.cd_pessoa_fisica,
		b.nr_sequencia,
		sum(CASE WHEN a.ie_perda_ganho='P' THEN  c.qt_volume  ELSE 0 END ) qt_volume
	from	atendimento_paciente d,
		tipo_perda_ganho b,
		grupo_perda_ganho a,
		atendimento_perda_ganho c
	where	d.nr_atendimento = c.nr_atendimento
	and	b.nr_sequencia = c.nr_seq_tipo
	and	b.nr_seq_grupo = a.nr_sequencia
	and     trunc(coalesce(c.dt_referencia,c.dt_medida)) = trunc(clock_timestamp()) - 1
	and     coalesce(b.ie_soma_bh,'S') = 'S'
	and (c.dt_liberacao IS NOT NULL AND c.dt_liberacao::text <> '')
	and     coalesce(c.ie_situacao,'A') = 'A'
	group by b.ds_tipo,
		d.cd_pessoa_fisica,
		b.nr_sequencia;



BEGIN

if (ie_periodo_p = 'H') then
	dt_inicial_w	:= dt_periodo_p - 1/1440;
	dt_final_w	:= dt_periodo_p;
elsif (ie_periodo_p = 'D') then
	dt_inicial_w	:= trunc(dt_periodo_p,'dd');
	dt_final_w	:= fim_dia(dt_periodo_p);
else
	dt_inicial_w	:= trunc(dt_periodo_p,'month');
	dt_final_w	:= fim_mes(dt_periodo_p);
end if;

open c01;
loop
	fetch c01 into	cd_pf_w,
			nr_prescricao_w,
			nr_seq_result_w,
			nr_seq_prescr_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	open c02;
	loop
		fetch c02 into	nr_seq_exame_w,
				ds_resultado_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

		if (ds_resultado_w IS NOT NULL AND ds_resultado_w::text <> '') then
			CALL gravar_informacao_pf(0, cd_pf_w, nr_seq_exame_w, 'E', ds_resultado_w, nm_usuario_p, 0);
		end if;
	end loop;
	close c02;

end loop;
close c01;

open C03;
loop
fetch C03 into
	cd_pf_w,
	nr_seq_perda_ganho_w,
	ds_resultado_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
		if (ds_resultado_w IS NOT NULL AND ds_resultado_w::text <> '') then
			CALL gravar_informacao_pf(0, cd_pf_w, nr_seq_perda_ganho_w, 'P', ds_resultado_w, nm_usuario_p, 0);
		end if;
	end;
end loop;
close C03;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_informacao_pf ( ie_periodo_p text, dt_periodo_p timestamp, nm_usuario_p text) FROM PUBLIC;

