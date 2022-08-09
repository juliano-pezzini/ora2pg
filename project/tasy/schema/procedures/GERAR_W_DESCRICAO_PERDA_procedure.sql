-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_descricao_perda (nr_cirurgia_p bigint, nr_seq_pepo_p bigint, nm_usuario_p text) AS $body$
DECLARE

ds_tipo_w		varchar(255);
qt_volume_w		bigint;


C01 CURSOR FOR
			SELECT		b.ds_tipo,
						a.qt_volume
			from		atendimento_perda_ganho a,
						tipo_perda_ganho b
			where		b.nr_sequencia = a.nr_seq_tipo
			and			coalesce(ie_perda_sanguinea,'N') = 'S'
			and			((nr_cirurgia = nr_cirurgia_p) or (coalesce(nr_cirurgia_p::text, '') = ''))
			and			((nr_seq_pepo = nr_seq_pepo_p) or (coalesce(nr_seq_pepo_p::text, '') = ''))
			and			(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
			and			coalesce(a.ie_situacao,'A') = 'A'
			order by 1;



BEGIN

delete
from	w_descricao_perda
where	nm_usuario	=	nm_usuario_p;

open C01;
loop
fetch C01 into
		ds_tipo_w,
		qt_volume_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	insert into w_descricao_perda(nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_cirurgia,
								nr_seq_pepo,
								ds_tipo,
								qt_volume_ml)
					values (nextval('w_descricao_perda_seq'),
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nr_cirurgia_p,
								nr_seq_pepo_p,
								ds_tipo_w,
								qt_volume_w);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_descricao_perda (nr_cirurgia_p bigint, nr_seq_pepo_p bigint, nm_usuario_p text) FROM PUBLIC;
