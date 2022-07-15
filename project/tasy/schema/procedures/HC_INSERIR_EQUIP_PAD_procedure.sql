-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hc_inserir_equip_pad (nr_seq_equipamento_p text, nr_seq_controle_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_equipamento_w	bigint;
qt_equipamento_w	integer;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		qt_itens_home_care
	from	hc_equipamento
	where	obter_se_contido(nr_sequencia,nr_seq_equipamento_p) = 'S'
	order by 1;

BEGIN
if (nr_seq_equipamento_p IS NOT NULL AND nr_seq_equipamento_p::text <> '') and (nr_seq_controle_p IS NOT NULL AND nr_seq_controle_p::text <> '') then

	open C01;
	loop
	fetch C01 into
		nr_seq_equipamento_w,
		qt_equipamento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		insert into hc_pad_equipamento(
			nr_sequencia,
			nr_seq_equipamento,
			dt_atualizacao,
			nm_usuario,
			nr_seq_controle,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			qt_equipamento)
		values (	nextval('hc_pad_equipamento_seq'),
			nr_seq_equipamento_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_controle_p,
			clock_timestamp(),
			nm_usuario_p,
			qt_equipamento_w);

		end;
	end loop;
	close C01;


end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hc_inserir_equip_pad (nr_seq_equipamento_p text, nr_seq_controle_p bigint, nm_usuario_p text) FROM PUBLIC;

