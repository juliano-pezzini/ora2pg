-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_ie_base_trib_nf () AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/nr_seq_prestador_w	bigint;
cd_estabelecimento_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_estabelecimento
	from	pls_prestador
	where	ie_valor_base_trib_nf = 'S';


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_prestador_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	insert into pls_regra_prest_trib(nr_sequencia,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_prestador,
		cd_tributo,
		ie_valor_base_trib_nf)
	values (nextval('pls_regra_prest_trib_seq'),
		cd_estabelecimento_w,
		clock_timestamp(),
		'Tasy',
		clock_timestamp(),
		'Tasy',
		nr_seq_prestador_w,
		null,
		'S');
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_ie_base_trib_nf () FROM PUBLIC;
