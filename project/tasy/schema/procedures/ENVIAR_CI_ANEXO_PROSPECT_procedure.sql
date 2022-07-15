-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_ci_anexo_prospect (nm_usuario_p text, nr_sequencia_P bigint, nr_seq_comunic_p bigint) AS $body$
DECLARE


nr_sequencia_arq_w bigint;
ds_anexo_w	 varchar(1000);


c01 CURSOR FOR
	SELECT  a.ds_anexo
	from    cml_prospect_anexo a,
  		cml_prospect b
	where   a.nr_seq_prospect = b.nr_sequencia
	and     b.nr_sequencia = nr_sequencia_p;


BEGIN

open c01;
loop
fetch c01 into
	ds_anexo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	nextval('comunic_interna_arq_seq')
	into STRICT	nr_sequencia_arq_w
	;

	insert 	into	comunic_interna_arq(
					nr_sequencia,
					nr_seq_comunic,
					dt_atualizacao,
					nm_usuario,
					ds_arquivo
					)
			 	 values (
					nr_sequencia_arq_w,
					nr_seq_comunic_p,
					clock_timestamp(),
					nm_usuario_p,
					ds_anexo_w
					);
			commit;
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_ci_anexo_prospect (nm_usuario_p text, nr_sequencia_P bigint, nr_seq_comunic_p bigint) FROM PUBLIC;

