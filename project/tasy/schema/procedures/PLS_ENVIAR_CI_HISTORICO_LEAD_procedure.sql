-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_enviar_ci_historico_lead () AS $body$
DECLARE


nr_seq_rtf_w			bigint;
ds_historico_w			varchar(4000);

C01 CURSOR FOR
	SELECT	a.nm_usuario_historico,
		a.nr_sequencia,
		substr(b.ds_atividade,1,255) ds_atividade,
		to_char(a.dt_programacao, 'dd/mm/yyyy hh24:mi:ss') dt_programacao,
		to_char(a.dt_historico, 'dd/mm/yyyy hh24:mi:ss') dt_historico
	from	pls_tipo_atividade		b,
		pls_solicitacao_historico 	a
	where	b.nr_sequencia = a.ie_tipo_atividade
	and	trunc(a.dt_programacao, 'dd') between trunc(clock_timestamp(), 'dd') and trunc(clock_timestamp(), 'dd') + 1
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	(a.nm_usuario_historico IS NOT NULL AND a.nm_usuario_historico::text <> '')
	and	b.ie_programacao = 'S';

BEGIN
for r_c01_w in C01 loop

	--Retira a formatação gerada pelo campo Panel editor do histórico para que a comunicação interna seja gerada corretamente.
	nr_seq_rtf_w := converte_rtf_string('select ds_historico from pls_solicitacao_historico where nr_sequencia = :nr_seq_solicitacao_hist', r_c01_w.nr_sequencia, 'Tasy', nr_seq_rtf_w);

	begin
	select	ds_texto
	into STRICT	ds_historico_w
	from	tasy_conversao_rtf
	where	nr_sequencia = nr_seq_rtf_w;
	exception
		when others then
			null;
	end;

	insert into comunic_interna(dt_comunicado,
		ds_titulo,
		ds_comunicado,
		nm_usuario,
		dt_atualizacao,
		ie_geral,
		nm_usuario_destino,
		cd_perfil,
		nr_sequencia,
		ie_gerencial,
		ds_setor_adicional,
		dt_liberacao,
		ds_grupo,
		nm_usuario_oculto)
	values (clock_timestamp(),
		r_c01_w.ds_atividade || ' - Dt programação: ' || r_c01_w.dt_programacao,
		'Dt histórico: ' || r_c01_w.dt_historico || chr(13) || ds_historico_w,
		'Tasy',
		clock_timestamp(),
		'N',
		r_c01_w.nm_usuario_historico,
		null,
		nextval('comunic_interna_seq'),
		'N',
		'',
		clock_timestamp(),
		'',
		'');
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_enviar_ci_historico_lead () FROM PUBLIC;

