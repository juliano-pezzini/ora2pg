-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_gerar_posic_gerencial ( dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE


ie_tema_posicao_w	varchar(15);
nr_seq_proj_w		bigint;
nr_seq_posicao_w	bigint;
ds_projeto_w		varchar(80);
ds_posicao_w		varchar(32000);
ds_item_w		varchar(255);

ds_mensagem_w		varchar(32000);

texto_comunic_w		varchar(32000);
ds_pos_inicio_rtf_w	bigint;

C01 CURSOR FOR  --Separa por temas
	SELECT	a.ie_tema_posicao
	from	proj_tipo_posic_item a,
		proj_posicao_coordenacao b
	where	a.nr_sequencia = b.nr_seq_posic_item
	and	b.ie_importante = 'S'
	and	(a.ie_tema_posicao IS NOT NULL AND a.ie_tema_posicao::text <> '')
	and	trunc(dt_posicao) = trunc(dt_referencia_p)
	group by a.ie_tema_posicao;


C02 CURSOR FOR  -- Separa projetos
	SELECT	b.nr_seq_proj
	from	proj_tipo_posic_item a,
		proj_posicao_coordenacao b
	where	a.nr_sequencia = b.nr_seq_posic_item
	and	b.ie_importante = 'S'
	and	trunc(dt_posicao) = trunc(dt_referencia_p)
	and	a.ie_tema_posicao = ie_tema_posicao_w
	group by b.nr_seq_proj;

C03 CURSOR FOR  -- Posicionamentos importantes do projeto
	SELECT	b.nr_sequencia
	from	proj_tipo_posic_item a,
		proj_posicao_coordenacao b
	where	a.nr_sequencia = b.nr_seq_posic_item
	and	trunc(dt_posicao) = trunc(dt_referencia_p)
	and	b.nr_seq_proj = nr_seq_proj_w
	and	a.ie_tema_posicao = ie_tema_posicao_w
	and	b.ie_importante = 'S'
	group by b.nr_sequencia;




BEGIN

delete from man_posicao_diaria_hist
where	trunc(dt_posicao) = trunc(dt_referencia_p)
and	nr_seq_gerencia = 1;
commit;


open C01;
loop
fetch C01 into
	ie_tema_posicao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ds_mensagem_w := 	'{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 Arial;}{\f1\fnil Arial;}}'||
							'{\colortbl ;\red0\green0\blue0;}' ||
							'\viewkind4\uc1\pard\cf1\lang1046\fs20 ';

	open C02;
	loop
	fetch C02 into
		nr_seq_proj_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		select	ds_titulo
		into STRICT	ds_projeto_w
		from	proj_projeto
		where	nr_sequencia = nr_seq_proj_w;

		ds_mensagem_w := ds_mensagem_w || '\par \f1 \par  \b '||ds_projeto_w||'\b0 \par \f0  '||' \par ';

		open C03;
		loop
		fetch C03 into
			nr_seq_posicao_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin

			select	b.ds_posicao,
				a.ds_item
			into STRICT	ds_posicao_w,
				ds_item_w
			from	proj_tipo_posic_item a,
				proj_posicao_coordenacao b
			where	a.nr_sequencia = b.nr_seq_posic_item
			and	b.nr_sequencia = nr_seq_posicao_w;

			ds_pos_inicio_rtf_w	:= position('lang1046' in ds_posicao_w)+8;
			texto_comunic_w 	:= substr(ds_posicao_w,1,ds_pos_inicio_rtf_w) || 'fs20 ';

			texto_comunic_w := texto_comunic_w || '\par '||substr(ds_posicao_w,ds_pos_inicio_rtf_w,length(ds_posicao_w));

			ds_mensagem_w := ds_mensagem_w ||'\par \f1 \par  \b               '|| ds_item_w || '\b0 \par \f0               '|| replace(ds_posicao_w,'\par ','\par               ');

			--ds_mensagem_w := ds_mensagem_w ||'\par \f1 \par  \b '|| ds_item_w || '\b0 \par \f0  '|| texto_comunic_w|| '\par \par ';
			end;
		end loop;
		close C03;

		end;
	end loop;
	close C02;

	ds_mensagem_w := ds_mensagem_w||'}';

	insert into man_posicao_diaria_hist(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						dt_posicao,
						nr_seq_gerencia,
						cd_pessoa_fisica,
						ie_tema_posicao,
						dt_liberacao,
						ds_posicao)
					values (	nextval('man_posicao_diaria_hist_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						dt_referencia_p,
						1,
						'118',
						ie_tema_posicao_w,
						clock_timestamp(),
						ds_mensagem_w);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_gerar_posic_gerencial ( dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
