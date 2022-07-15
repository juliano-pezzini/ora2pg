-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_questionario_servico ( nr_seq_servico_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE



ds_servico_w			varchar(40);
nr_seq_pergunta_w			bigint;
nr_seq_modelo_w			bigint;
nr_seq_apres_w			bigint	:= 0;
nr_seq_serv_quest_w		bigint;

C01 CURSOR FOR
	SELECT	nr_seq_pergunta
	from	servico_pergunta
	where	nr_seq_servico	= nr_seq_servico_p
	and	ie_situacao	= 'A';

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	servico_questionario
	where	nr_seq_servico	= nr_seq_servico_p
	and	nr_sequencia <> nr_seq_serv_quest_w;


BEGIN

select	substr(ds_servico,1,40)
into STRICT	ds_servico_w
from	servico
where	nr_sequencia	 = nr_seq_servico_p;

select	nextval('modelo_seq')
into STRICT	nr_seq_modelo_w
;

insert into modelo(	nr_sequencia,
		ie_situacao,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_modelo,
		ie_classificacao)
	values(	nr_seq_modelo_w,
		'A',
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		substr(wheb_mensagem_pck.get_texto(305762, 'DS_SERVICO_W=' || ds_servico_w || ';DT_ATUALIZACAO=' || to_char(clock_timestamp(),'dd/mm/yyyy')),1,60), -- 'Serviço: ' || ds_servico_w || ' - ' || to_char(clock_timestamp(),'dd/mm/yyyy')
		3);

open C01;
loop
fetch C01 into
	nr_seq_pergunta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	nr_seq_apres_w	:= nr_seq_apres_w + 1;

	insert into modelo_conteudo(	nr_sequencia,
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
				nr_seq_apres)
			values (	nextval('modelo_conteudo_seq'),
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_modelo_w,
				'N',
				'N',
				'S',
				nr_seq_pergunta_w,
				'N',
				'N',
				15,
				'N',
				'N',
				200,
				nr_seq_apres_w);
	end;
end loop;
close C01;

select	nextval('servico_questionario_seq')
into STRICT	nr_seq_serv_quest_w
;

insert into servico_questionario(nr_sequencia,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nm_usuario_nrec,
		nr_seq_servico,
		nr_seq_modelo,
		dt_inicio_vigencia)
	values (	nr_seq_serv_quest_w,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		nr_seq_servico_p,
		nr_seq_modelo_w,
		clock_timestamp());

open C02;
loop
fetch C02 into
	nr_seq_serv_quest_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	update	servico_questionario
	set	dt_fim_vigencia	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_serv_quest_w;
	end;
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_questionario_servico ( nr_seq_servico_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

