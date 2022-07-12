-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION exibe_inf_tratamento_sessao (nr_seq_agenda_p bigint, ie_informacao_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_final_w	varchar(1000);

ds_retorno_w 		varchar(2000);
ds_msgm_inf_i_w		varchar(1000);
ds_msgm_inf_t_w		varchar(1000);
ds_msgm_inf_s_w		varchar(1000);
ds_sessao_w		varchar(50);
qt_total_secao_w		agenda_consulta.qt_total_secao%type;
nr_secao_w		agenda_consulta.nr_secao%type;
nr_secao_ww		agenda_consulta.nr_secao%type;
menor_nr_secao_w		agenda_consulta.nr_secao%type;
nr_controle_secao_w	agenda_consulta.nr_controle_secao%type;
dt_agenda_w		agenda_consulta.dt_agenda%type;


C01 CURSOR FOR
	SELECT 	nr_secao,
		dt_agenda
	from	agenda_consulta
	where	nr_controle_secao = nr_controle_secao_w
	and	nr_secao > nr_secao_ww
	and	ie_status_agenda not in ('C','F','I','S')
	order by   dt_agenda;


BEGIN

if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (ie_informacao_p IS NOT NULL AND ie_informacao_p::text <> '') then

	-- RETORNA O CONTROLE E NUMERO DA SESSAO ATUAL
	select	nr_controle_secao,
		nr_secao
	into STRICT	nr_controle_secao_w,
		nr_secao_ww
	from	agenda_consulta
	where	nr_sequencia = nr_seq_agenda_p;

	-- VERIFICA QUAL A PRIMEIRA SESSÃO DO PACIENTE
	select 	min(nr_secao)
	into STRICT	menor_nr_secao_w
	from	agenda_consulta
	where	nr_controle_secao = nr_controle_secao_w;

	if (nr_controle_secao_w IS NOT NULL AND nr_controle_secao_w::text <> '') then

		-- RETORNA ULTIMA SECAO DO PACIENTE
		select 	max(qt_total_secao)
		into STRICT	qt_total_secao_w
		from	agenda_consulta
		where	nr_controle_secao = nr_controle_secao_w;

	end if;

	-- IE_INFORMACAO_P = 'I'
	if (nr_secao_ww = menor_nr_secao_w) then
		/*
		ds_msgm_inf_i_w := 'Esta é a primeira sessão do tratamento do paciente de' || chr(13) ||
				   'um total de ' || qt_total_secao_w || ' sessões. Segue a relação dos próximos' || chr(13) ||
				   'agendamentos vinculados a esta sessão do paciente' || chr(13) || chr(13);
		*/
		ds_msgm_inf_i_w	:= obter_texto_tasy(404070, wheb_usuario_pck.get_nr_seq_idioma) || chr(13) ||
				   obter_texto_tasy(404549, wheb_usuario_pck.get_nr_seq_idioma) || chr(13) ||
				   obter_texto_tasy(404550, wheb_usuario_pck.get_nr_seq_idioma) || chr(13) || chr(13);

		ds_msgm_inf_i_w	:= replace(ds_msgm_inf_i_w, '#@QT_TOTAL_SECAO#@', qt_total_secao_w);

	end if;

	-- IE_INFORMACAO_P = 'T'
	if (nr_secao_ww = qt_total_secao_w) then
		/*
		ds_msgm_inf_t_w := 'Esta é a última sessão do tratamento do paciente de um total de ' || qt_total_secao_w || ' sessões.';
		*/
		ds_msgm_inf_t_w := obter_texto_tasy(404551, wheb_usuario_pck.get_nr_seq_idioma);
		ds_msgm_inf_t_w	:= replace(ds_msgm_inf_t_w, '#@QT_TOTAL_SECAO#@', qt_total_secao_w);

	end if;

	-- IE_INFORMACAO_P = 'S'
	if (nr_secao_ww > menor_nr_secao_w) and (nr_secao_ww < qt_total_secao_w) then
	        /*
		ds_msgm_inf_s_w := 'Esta é a ' || nr_secao_ww || 'ª sessão do tratamento do paciente de um '|| chr(13) ||
				   'total de ' || qt_total_secao_w || ' sessões. Segue a relação dos próximos' || chr(13) ||
				   'agendamentos vinculados a esta sessão do paciente' || chr(13) || chr(13);
		*/
		ds_msgm_inf_s_w := obter_texto_tasy(406107, wheb_usuario_pck.get_nr_seq_idioma);

		ds_msgm_inf_s_w := replace(ds_msgm_inf_s_w, '#@NR_SESSAO#@', nr_secao_ww);

		ds_msgm_inf_s_w := ds_msgm_inf_s_w || chr(13) ||
				   obter_texto_tasy(404549, wheb_usuario_pck.get_nr_seq_idioma) || chr(13) ||
				   obter_texto_tasy(404550, wheb_usuario_pck.get_nr_seq_idioma) || chr(13) || chr(13);

		ds_msgm_inf_s_w := replace(ds_msgm_inf_s_w, '#@QT_TOTAL_SECAO#@', qt_total_secao_w);

	end if;

	-- Sessão
	ds_sessao_w := obter_texto_tasy(407055, wheb_usuario_pck.get_nr_seq_idioma);

	open C01;
	loop
	fetch C01 into
		nr_secao_w,
		dt_agenda_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if ((ie_informacao_p = 'I') or (ie_informacao_p = 'S') or (ie_informacao_p = 'IT')) and (nr_secao_w > menor_nr_secao_w) then

			if (coalesce(ds_retorno_w::text, '') = '') then
				ds_retorno_w := ds_sessao_w||' '||nr_secao_w||'/'||qt_total_secao_w||': '||to_char(dt_agenda_w, 'dd/mm/yyyy hh24:mi');
			else
				ds_retorno_w := ds_retorno_w || chr(13) || ds_sessao_w||' '||nr_secao_w||'/'||qt_total_secao_w||': '||to_char(dt_agenda_w, 'dd/mm/yyyy hh24:mi');
			end if;

		end if;

		end;
	end loop;
	close C01;

end if;

if ((ie_informacao_p = 'I') or (ie_informacao_p = 'S') or (ie_informacao_p = 'IT')) and (ds_msgm_inf_i_w IS NOT NULL AND ds_msgm_inf_i_w::text <> '') and (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
	ds_retorno_final_w := ds_msgm_inf_i_w || ds_retorno_w;

elsif ((ie_informacao_p = 'T') or (ie_informacao_p = 'S') or (ie_informacao_p = 'IT')) and (ds_msgm_inf_t_w IS NOT NULL AND ds_msgm_inf_t_w::text <> '') then
	ds_retorno_final_w := ds_msgm_inf_t_w;

elsif (ie_informacao_p = 'S') and (ds_msgm_inf_s_w IS NOT NULL AND ds_msgm_inf_s_w::text <> '') and (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
	ds_retorno_final_w := ds_msgm_inf_s_w || ds_retorno_w;
end if;

return	ds_retorno_final_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION exibe_inf_tratamento_sessao (nr_seq_agenda_p bigint, ie_informacao_p text) FROM PUBLIC;
