-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_atualiza_cd_guia_ok () AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Popular o campo cd_guia_ok da tabela pls_conta. Este campo foi criado
	para conter o valor do nvl(cd_guia_referencia, cd_guia).
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
i			bigint;
qt_contas_w		bigint;
qtd_registros_commit_w	integer := 100;


BEGIN

dbms_application_info.SET_ACTION('BACACDGUIAOK');

select	count(1)
into STRICT	qt_contas_w
from	pls_conta a
where 	coalesce(cd_guia_ok::text, '') = ''
and ((cd_guia_referencia IS NOT NULL AND cd_guia_referencia::text <> '') or (cd_guia IS NOT NULL AND cd_guia::text <> ''));

i	:= 0;
while(i <= qt_contas_w / qtd_registros_commit_w) loop
	update	pls_conta
	set	cd_guia_ok = coalesce(cd_guia_referencia, cd_guia),
		ie_tipo_conta = 'Y' where	coalesce(cd_guia_ok::text, '') = ''
	and ((cd_guia_referencia IS NOT NULL AND cd_guia_referencia::text <> '') or (cd_guia IS NOT NULL AND cd_guia::text <> '')) LIMIT (qtd_registros_commit_w);

	commit;

	i	:= i + 1;
end loop;

dbms_application_info.SET_ACTION(null);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_atualiza_cd_guia_ok () FROM PUBLIC;
