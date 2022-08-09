-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_motivo_estorno_nf ( nr_sequencia_p bigint, nr_seq_mot_cancel_p text, ds_motivo_estorno_p text) AS $body$
DECLARE


ds_observacao_w		nota_fiscal.ds_observacao%type;
ds_observacao_ww		nota_fiscal.ds_observacao%type;
nr_seq_estorno_w		nota_fiscal.nr_sequencia%type;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin

	select	substr(ds_observacao,1,4000)
	into STRICT	ds_observacao_w
	from	nota_fiscal
	where	nr_sequencia = nr_sequencia_p;

	if (coalesce(ds_observacao_w::text, '') = '') then
		ds_observacao_ww := substr(ds_motivo_estorno_p,1,3950);
	else
		ds_observacao_ww := substr(ds_observacao_w || chr(13) || chr(10) || ds_motivo_estorno_p,1,3950);
	end if;

	update 	nota_fiscal
	set 	ds_observacao = ds_observacao_ww,
		nr_seq_motivo_cancel = nr_seq_mot_cancel_p
	where 	nr_sequencia = nr_sequencia_p;

	select	max(coalesce(nr_sequencia,0))
	into STRICT	nr_seq_estorno_w
	from	nota_fiscal
	where	nr_sequencia_ref = nr_sequencia_p
	and	ie_situacao = '2';

	if (nr_seq_estorno_w > 0)	then
		update 	nota_fiscal
		set 	ds_observacao = ds_observacao_ww
		where 	nr_sequencia = nr_seq_estorno_w;
	end if;

	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_motivo_estorno_nf ( nr_sequencia_p bigint, nr_seq_mot_cancel_p text, ds_motivo_estorno_p text) FROM PUBLIC;
