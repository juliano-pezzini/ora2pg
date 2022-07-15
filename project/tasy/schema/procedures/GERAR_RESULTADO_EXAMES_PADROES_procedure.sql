-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_resultado_exames_padroes (nr_atendimento_p bigint, nr_seq_cliente_p bigint, cd_medico_p text, dt_resultado_p timestamp, nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nr_seq_exame_lab_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_exame_w				bigint;
nr_sequencia_w				bigint;
nr_atendimento_w			bigint;
vl_padrao_w				varchar(15);
ie_dupl_coluna_data_w			varchar(15);
ie_duplica_w				varchar(1);

c01 CURSOR FOR
	SELECT 	a.nr_sequencia,
		'N' ie_duplica
	from 	med_exame_padrao a
	where	a.ie_resultado	= 'S'
	and	a.ie_padrao	= 'S'
	and	a.cd_medico	= cd_medico_p
	and	not exists (	SELECT 1
				from med_result_exame b
				where	b.nr_seq_cliente	= nr_seq_cliente_p
				and	b.nr_seq_exame		= a.nr_sequencia
				and	b.dt_exame		= trunc(dt_resultado_p))
	
union

	select 	a.nr_sequencia,
		'S' ie_duplica
	from 	med_exame_padrao a
	where	ie_dupl_coluna_data_w 	= 'S'
	and	a.ie_resultado		= 'S'
	and	a.ie_padrao		= 'S'
	and	a.cd_medico		= cd_medico_p
	and	exists (	select 1
				from med_result_exame b
				where	b.nr_seq_cliente	= nr_seq_cliente_p
				and	b.nr_seq_exame		= a.nr_sequencia
				and	b.dt_exame		= trunc(dt_resultado_p)
				and	b.nr_seq_exame_lab	= nr_seq_exame_lab_p
				and	((b.nr_prescricao	<> nr_prescricao_p) or (b.nr_seq_prescricao	<> nr_seq_prescricao_p)));





BEGIN

select coalesce(max(vl_padrao),'S')
into STRICT   vl_padrao_w
from   med_parametro
where  nr_sequencia = 83;

select 	coalesce(max(vl_parametro),vl_padrao_w)
into STRICT	ie_dupl_coluna_data_w
from   	med_parametro_medico
where  	nr_seq_parametro 	= 83
and	cd_medico 		= cd_medico_p;


nr_atendimento_w		:= nr_atendimento_p;
if (nr_atendimento_w = 0) then
	nr_atendimento_w	:= null;
end if;
open	c01;
loop
fetch	c01 into
	nr_seq_exame_w,
	ie_duplica_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	nextval('med_result_exame_seq')
	into STRICT	nr_sequencia_w
	;

	insert	into med_result_exame(nr_sequencia,
		nr_atendimento,
		nr_seq_exame,
		dt_exame,
		dt_atualizacao,
		nm_usuario,
		ds_valor_exame,
		vl_exame,
		nr_seq_cliente,
		nr_prescricao,
		nr_seq_prescricao,
		nr_seq_exame_lab)
	values (nr_sequencia_w,
		nr_atendimento_w,
		nr_seq_exame_w,
		trunc(dt_resultado_p),
		clock_timestamp(),
		nm_usuario_p,
		null,
		null,
		nr_seq_cliente_p,
		CASE WHEN ie_duplica_w='S' THEN nr_prescricao_p  ELSE null END ,
		CASE WHEN ie_duplica_w='S' THEN nr_seq_prescricao_p  ELSE null END ,
		CASE WHEN ie_duplica_w='S' THEN nr_seq_exame_lab_p  ELSE null END );
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_resultado_exames_padroes (nr_atendimento_p bigint, nr_seq_cliente_p bigint, cd_medico_p text, dt_resultado_p timestamp, nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nr_seq_exame_lab_p bigint, nm_usuario_p text) FROM PUBLIC;

