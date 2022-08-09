-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_acerto_composicao_nut () AS $body$
DECLARE


nr_seq_composicao_w	bigint;
nr_seq_servico_w	bigint;
dt_atualizacao_w	timestamp;
nm_usuario_w		varchar(15);
ie_situacao_w		varchar(01);
qt_reg_w		bigint;
nr_sequencia_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_servico,
		dt_atualizacao,
		nm_usuario,
		ie_situacao
	from	nut_composicao
	where	(nr_seq_servico IS NOT NULL AND nr_seq_servico::text <> '')
	order by 1;


BEGIN

select	count(*)
into STRICT	qt_reg_w
from	nut_comp_servico;


if (qt_reg_w	= 0) then
	begin
	open C01;
	loop
	fetch 	C01 into
		nr_seq_composicao_w,
		nr_seq_servico_w,
		dt_atualizacao_w,
		nm_usuario_w,
		ie_situacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	nextval('nut_comp_servico_seq')
		into STRICT	NR_SEQUENCIA_w
		;

		insert	into nut_comp_servico(NR_SEQUENCIA,
			NR_SEQ_SERVICO,
			NR_SEQ_COMPOSICAO,
			DT_ATUALIZACAO,
			NM_USUARIO,
			DT_ATUALIZACAO_NREC,
			NM_USUARIO_NREC,
			IE_SITUACAO)
		values (NR_SEQUENCIA_w,
			nr_seq_servico_w,
			nr_seq_composicao_w,
			dt_atualizacao_w,
			nm_usuario_w,
			dt_atualizacao_w,
			nm_usuario_w,
			ie_situacao_w);

		end;
	end loop;
	close C01;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_acerto_composicao_nut () FROM PUBLIC;
