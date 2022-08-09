-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_classif_depend ( nr_seq_segurado_p bigint, nr_seq_classif_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_classif_dependencia_w	pls_classif_dependencia.nr_sequencia%type;
nr_seq_classif_depen_ant_w	pls_classif_dependencia.nr_sequencia%type;
ds_classificacao_w		pls_classif_dependencia.ds_classificacao%type;
ds_classificacao_ant_w		pls_classif_dependencia.ds_classificacao%type;


BEGIN

select 	max(nr_seq_classif_dependencia)
into STRICT	nr_seq_classif_depen_ant_w
from 	pls_segurado
where 	nr_sequencia = nr_seq_segurado_p;

nr_seq_classif_dependencia_w := coalesce(nr_seq_classif_p,0);

if (nr_seq_classif_depen_ant_w IS NOT NULL AND nr_seq_classif_depen_ant_w::text <> '') and (nr_seq_classif_dependencia_w <> nr_seq_classif_depen_ant_w) then

	select	ds_classificacao
	into STRICT	ds_classificacao_w
	from	pls_classif_dependencia
	where	nr_sequencia	= nr_seq_classif_dependencia_w;

	select	ds_classificacao
	into STRICT	ds_classificacao_ant_w
	from	pls_classif_dependencia
	where	nr_sequencia	= nr_seq_classif_depen_ant_w;

	ds_classificacao_ant_w := substr(to_char(nr_seq_classif_depen_ant_w) || ' - ' || ds_classificacao_ant_w, 1,255);
	ds_classificacao_w := substr(to_char(nr_seq_classif_dependencia_w) || ' - ' || ds_classificacao_w, 1,255);

	CALL pls_gerar_segurado_historico(nr_seq_segurado_p, '75', clock_timestamp(),
				     wheb_mensagem_pck.get_texto(294153, 'DS_CLASSIF_DEPENDENCIA_ANT=' || ds_classificacao_ant_w || ';DS_CLASSIF_DEPENDENCIA=' || ds_classificacao_w),
				     null, null, null, null,
				     null, null, null, null,
				     null, null, null, null,
				     nm_usuario_p, 'N');
end if;

update	pls_segurado
set	nr_seq_classif_dependencia	= nr_seq_classif_dependencia_w
where	nr_sequencia			= nr_seq_segurado_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_classif_depend ( nr_seq_segurado_p bigint, nr_seq_classif_p bigint, nm_usuario_p text) FROM PUBLIC;
