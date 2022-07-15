-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_dropar_tabela_rxt () AS $body$
DECLARE


nm_tabela_w	varchar(50);

c01 CURSOR FOR
SELECT	nm_tabela
from	tabela_sistema
where	substr(upper(nm_tabela),1,3)	= 'RXT'
and	upper(nm_tabela)		<> 'RXT_TIPO'
and	upper(nm_tabela)		<> 'RXT_EQUIP_TIPO'
and	upper(nm_tabela)		<> 'RXT_ACESSORIO'
and	upper(nm_tabela)		<> 'RXT_EQUIPAMENTO'
and	upper(nm_tabela)		<> 'RXT_TUMOR'
and	upper(nm_tabela)		<> 'RXT_TRATAMENTO'
and	upper(nm_tabela)		<> 'RXT_CAMPO'
and	upper(nm_tabela)		<> 'RXT_ACESSORIO_PAC'
order by
	nm_tabela;


BEGIN

open c01;
loop
fetch c01 into nm_tabela_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	/* dropar tabela */

	CALL exec_sql_dinamico('Tasy','drop table ' || nm_tabela_w);

	/* excluir tabela dicionario */

	CALL exec_sql_dinamico_bv('Tasy','delete from tabela_sistema where nm_tabela = :nm_tabela','nm_tabela=' || nm_tabela_w);

	end;

end loop;
close c01;

/* dropar objetos */

CALL exec_sql_dinamico('Tasy','drop function obter_acessorio_agenda_rxt'
);
CALL exec_sql_dinamico('Tasy','drop function obter_desc_paciente_rxt'
);
CALL exec_sql_dinamico('Tasy','drop function obter_prev_termino'
);
CALL exec_sql_dinamico('Tasy','drop procedure atualizar_simulacao_rxt'
);
CALL exec_sql_dinamico('Tasy','drop procedure atualizar_tratamento_rxt'
);
CALL exec_sql_dinamico('Tasy','drop procedure gerar_agenda_equipamento_rxt'
);
CALL exec_sql_dinamico('Tasy','drop procedure gerar_agenda_futura_rxt'
);
CALL exec_sql_dinamico('Tasy','drop trigger rxt_paciente_update');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_dropar_tabela_rxt () FROM PUBLIC;

