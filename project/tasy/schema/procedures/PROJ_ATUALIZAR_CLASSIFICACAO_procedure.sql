-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_atualizar_classificacao ( nr_seq_cronograma_p bigint, nr_seq_superior_p bigint, ie_classif_p text, ie_contador_p bigint, nr_seq_ordenacao_p bigint, nr_seq_ordenacao_out_p INOUT bigint) AS $body$
DECLARE



nr_sequencia_w		bigint;
ie_classif_w		varchar(255);
ie_contador_w		bigint;
nr_seq_ordenacao_w	bigint;
nr_seq_ordenacao_ww	bigint;

c01 CURSOR FOR
SELECT	nr_sequencia
from	proj_cron_etapa
where	nr_seq_cronograma = nr_seq_cronograma_p
and	coalesce(nr_seq_superior, 0) = nr_seq_superior_p
and	coalesce(ie_situacao,'A') = 'A'
order by	coalesce(nr_seq_interno,nr_seq_apres),
	cd_classificacao;


BEGIN

nr_seq_ordenacao_w	:= nr_seq_ordenacao_p + 1;
ie_contador_w	:= 1;

OPEN C01;
LOOP
FETCH C01 INTO
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_classif_w	:= ie_classif_p;
	if (ie_classif_w = '0') then
		ie_classif_w	:= '1';
	else
		ie_classif_w	:= substr(ie_classif_w || '.' || substr(to_char(ie_contador_w,'000'),2,10),1,255);
	end if;

	update	proj_cron_etapa
	set	cd_classificacao = ie_classif_w,
		nr_seq_ordenacao = nr_seq_ordenacao_w
	where	nr_sequencia = nr_sequencia_w;
	commit;

	nr_seq_ordenacao_ww := proj_atualizar_classificacao(
		nr_seq_cronograma_p, nr_sequencia_w, ie_classif_w, ie_contador_w, nr_seq_ordenacao_w, nr_seq_ordenacao_ww);

	nr_seq_ordenacao_w	:= coalesce(nr_seq_ordenacao_ww, nr_seq_ordenacao_w + 1);
	ie_contador_w	:= ie_contador_w + 1;
	end;
end loop;
close c01;

nr_seq_ordenacao_out_p	:= nr_seq_ordenacao_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_atualizar_classificacao ( nr_seq_cronograma_p bigint, nr_seq_superior_p bigint, ie_classif_p text, ie_contador_p bigint, nr_seq_ordenacao_p bigint, nr_seq_ordenacao_out_p INOUT bigint) FROM PUBLIC;

