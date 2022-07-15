-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE definir_prescr_nutri_todos_js ( nr_atendimento_p bigint, nr_prescricao_p bigint, ie_tipo_p text, ie_opcao_p text, nr_seq_serv_dia_p bigint, nr_seq_serv_dia_lista_p text, nm_usuario_p text, ds_pergunta_p INOUT text) AS $body$
DECLARE


/*	ie_opcao_p
	C - Consistir dados
	E - Execuatr
	D - Desfazer
	*/
nr_seq_serv_dia_w		bigint;
ds_pergunta_w		varchar(255);
nr_seq_serv_dia_lista_w	varchar(4000);
nr_seq_serv_rep_w		bigint;

C01 CURSOR FOR
	SELECT	b.nr_sequencia
	from	nut_atend_serv_dia b
	where	b.nr_atendimento = nr_atendimento_p
	and	coalesce(b.dt_liberacao::text, '') = ''
	and	exists
		(SELECT	1
		from	prescr_medica a,
			nut_servico f,
			nut_servico_horario e
		where	b.nr_atendimento = a.nr_atendimento
		and	(coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '')
		and	a.nr_prescricao = nr_prescricao_p
		and   	f.nr_sequencia = b.nr_seq_servico
		and   	e.nr_seq_servico = f.nr_sequencia
		and	((PKG_DATE_UTILS.get_Time(b.dt_servico, e.ds_horarios_fim) between a.dt_inicio_prescr and a.dt_validade_prescr) or (coalesce(a.dt_validade_prescr::text, '') = '')
			or	((PKG_DATE_UTILS.get_Time(b.dt_servico, e.ds_horarios) between a.dt_inicio_prescr and a.dt_validade_prescr) or (coalesce(a.dt_validade_prescr::text, '') = '')))
		and (	exists (select 1 from prescr_dieta b where a.nr_prescricao = b.nr_prescricao)
			or	exists (select 1 from rep_jejum c where a.nr_prescricao = c.nr_prescricao)
			or	exists (select 1 from prescr_material d where a.nr_prescricao = d.nr_prescricao and d.ie_agrupador in (8,12))
			or	exists (select 1 from nut_pac e where a.nr_prescricao = e.nr_prescricao)
			or    	exists (select 1 from prescr_leite_deriv e where a.nr_prescricao = e.nr_prescricao)));


BEGIN
ds_pergunta_p	:= '';

if (ie_opcao_p = 'C') then
	begin
	open C01;
	loop
	fetch C01 into	
		nr_seq_serv_dia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ds_pergunta_w := definir_prescricao_nutricao_js(
			ie_tipo_p, ie_opcao_p, nr_seq_serv_dia_w, nr_prescricao_p, nm_usuario_p, ds_pergunta_w);

		if (ds_pergunta_w IS NOT NULL AND ds_pergunta_w::text <> '') then
			ds_pergunta_p	:= ds_pergunta_p || '#@#@' || nr_seq_serv_dia_w || '#@#@' || ds_pergunta_w;
		ds_pergunta_w	:= '';
		end if;
		end;
	end loop;
	close C01;

	if (ds_pergunta_p IS NOT NULL AND ds_pergunta_p::text <> '') then
		ds_pergunta_p	:= substr(ds_pergunta_p, 5, length(ds_pergunta_p));
	end if;
	end;

elsif (ie_opcao_p = 'E') then
	begin
	nr_seq_serv_dia_lista_w	:= nr_seq_serv_dia_lista_w;

	while (nr_seq_serv_dia_lista_w IS NOT NULL AND nr_seq_serv_dia_lista_w::text <> '') loop
		begin
		nr_seq_serv_dia_w		:= substr(nr_seq_serv_dia_lista_w, 1, position(',' in nr_seq_serv_dia_lista_w) - 1);
		nr_seq_serv_dia_lista_w	:= substr(nr_seq_serv_dia_lista_w, position(',' in nr_seq_serv_dia_lista_w) + 1, length(nr_seq_serv_dia_lista_w));

		ds_pergunta_w := definir_prescricao_nutricao_js(
			ie_tipo_p, ie_opcao_p, nr_seq_serv_dia_w, nr_prescricao_p, nm_usuario_p, ds_pergunta_w);
		end;
	end loop;
	end;

elsif (ie_opcao_p = 'D') then
	begin
	
	open C01;
	loop
	fetch C01 into	
		nr_seq_serv_dia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		select	coalesce(max(nr_sequencia), 0)
		into STRICT	nr_seq_serv_rep_w
		from	nut_atend_serv_dia_rep
		where	nr_seq_serv_dia = nr_seq_serv_dia_w
		and	coalesce(dt_liberacao::text, '') = '';	
		
		CALL desfazer_prescricao_nutricao(
			nr_prescricao_p,
			nr_seq_serv_rep_w,
			nr_seq_serv_dia_w,
			ie_tipo_p,
			nm_usuario_p);
		end;
	end loop;
	close C01;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE definir_prescr_nutri_todos_js ( nr_atendimento_p bigint, nr_prescricao_p bigint, ie_tipo_p text, ie_opcao_p text, nr_seq_serv_dia_p bigint, nr_seq_serv_dia_lista_p text, nm_usuario_p text, ds_pergunta_p INOUT text) FROM PUBLIC;

