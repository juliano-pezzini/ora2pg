-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_pergunta_modelo_vig ( nr_seq_pergunta_p bigint, nr_seq_servico_p bigint, nm_usuario_p text, nr_seq_modelo_p INOUT bigint) AS $body$
DECLARE


nr_seq_modelo_w			bigint;
nr_seq_apres_w			bigint;
qt_existe_w			bigint;


BEGIN

nr_seq_modelo_p	:= 0;

select	coalesce(max(nr_seq_modelo),0)
into STRICT	nr_seq_modelo_w
from	servico_questionario
where	nr_seq_servico = nr_seq_servico_p
and	trunc(clock_timestamp()) between trunc(coalesce(dt_inicio_vigencia,clock_timestamp()))
			and trunc(coalesce(dt_fim_vigencia,clock_timestamp()));
select	count(*)
into STRICT	qt_existe_w
from	modelo_conteudo
where	nr_seq_modelo = nr_seq_modelo_w
and	nr_seq_pergunta = nr_seq_pergunta_p;

if (nr_seq_modelo_w <> 0) and (qt_existe_w = 0) then
	begin

	select	coalesce(max(nr_seq_apres),0) + 5
	into STRICT	nr_seq_apres_w
	from	modelo_conteudo
	where	nr_seq_modelo = nr_seq_modelo_w;

	insert into modelo_conteudo(
		nr_sequencia,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nr_seq_modelo,
		ie_readonly,
		ie_obrigatorio,
		ie_tabstop,
		nr_seq_pergunta,
		ie_negrito,
		ie_italico,
		qt_altura_perg_visual,
		ie_apres_cad_pre,
		ie_sublinhado,
		qt_tamanho,
		nr_seq_apres) values (
			nextval('modelo_conteudo_seq'),
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_modelo_w,
			'N',
			'N',
			'S',
			nr_seq_pergunta_p,
			'N',
			'N',
			15,
			'N',
			'N',
			200,
			nr_seq_apres_w);

	commit;

	nr_seq_modelo_p	:= nr_seq_modelo_w;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_pergunta_modelo_vig ( nr_seq_pergunta_p bigint, nr_seq_servico_p bigint, nm_usuario_p text, nr_seq_modelo_p INOUT bigint) FROM PUBLIC;
