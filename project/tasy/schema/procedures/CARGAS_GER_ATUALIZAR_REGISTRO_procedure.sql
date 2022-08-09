-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cargas_ger_atualizar_registro ( nm_usuario_p ger_tipo_carga_arq.nm_usuario%type, nm_tabela_p ger_tipo_carga_arq.nm_tabela%type, nr_seq_carga_arq_p ger_carga_arq.nr_sequencia%type, nm_campo_p ger_tipo_carga_campo.nm_campo%type, ds_lista_seq_p text default null, ie_tipo_alteracao_p bigint DEFAULT NULL, vl_novo_p text default null, ie_nulo_novo_p text default 'N', vl_anterior_p text default null, ie_nulo_anterior_p text default 'N') AS $body$
DECLARE

ds_script_w         varchar(4000);
ie_tipo_campo_w     ger_tipo_carga_campo.ie_tipo_campo%type;
lista_seq_w         dbms_sql.varchar2_table;
nr_sequencia_w	    bigint;

BEGIN

select  b.ie_tipo_campo
into STRICT    ie_tipo_campo_w
from    ger_carga_arq a,
        ger_tipo_carga_campo b
where   a.nr_sequencia = nr_seq_carga_arq_p
and     a.nr_seq_tipo_arq = b.nr_seq_arquivo
and     nm_campo = nm_campo_p;

ds_script_w :=  ' update ' || nm_tabela_p ||
                ' set nm_usuario = ' ||chr(39) || nm_usuario_p ||chr(39) || ',' ||
                '     dt_atualizacao  = sysdate,';
if (ie_nulo_novo_p = 'S') then
    ds_script_w:= ds_script_w || ' ' || nm_campo_p || ' = null';
elsif (ie_tipo_campo_w = 'VARCHAR2') then
    ds_script_w:= ds_script_w || ' ' || nm_campo_p || ' = ' ||chr(39) || vl_novo_p || chr(39);
else
    ds_script_w:= ds_script_w || ' ' || nm_campo_p || ' = ' || vl_novo_p;
end if;

ds_script_w := ds_script_w ||
                ' where ie_status <> '||chr(39) || 'I' || chr(39) ||
                ' and nr_seq_carga_arq = ' || nr_seq_carga_arq_p;

if (ie_nulo_anterior_p = 'S') then
    ds_script_w := ds_script_w ||
                ' and ' || nm_campo_p || ' is null';
elsif (ie_tipo_campo_w = 'VARCHAR2' and (vl_anterior_p IS NOT NULL AND vl_anterior_p::text <> '')) then
    ds_script_w := ds_script_w ||
                ' and ' || nm_campo_p || ' = ' ||chr(39) || vl_anterior_p || chr(39);
elsif (vl_anterior_p IS NOT NULL AND vl_anterior_p::text <> '') then
    ds_script_w := ds_script_w ||
                ' and ' || nm_campo_p || ' = ' || vl_anterior_p;
end if;

if (ie_tipo_alteracao_p = 1) then
    if (ds_lista_seq_p IS NOT NULL AND ds_lista_seq_p::text <> '')then
        lista_seq_w	:=	obter_lista_string(ds_lista_seq_p, ',');
        for i in lista_seq_w.first..lista_seq_w.last loop
            nr_sequencia_w	:= lista_seq_w(i);
            CALL exec_sql_dinamico('CARGAS', (ds_script_w || ' and nr_sequencia = ' || nr_sequencia_w));
        end loop;
    end if;
else
	CALL exec_sql_dinamico('CARGAS', ds_script_w);	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cargas_ger_atualizar_registro ( nm_usuario_p ger_tipo_carga_arq.nm_usuario%type, nm_tabela_p ger_tipo_carga_arq.nm_tabela%type, nr_seq_carga_arq_p ger_carga_arq.nr_sequencia%type, nm_campo_p ger_tipo_carga_campo.nm_campo%type, ds_lista_seq_p text default null, ie_tipo_alteracao_p bigint DEFAULT NULL, vl_novo_p text default null, ie_nulo_novo_p text default 'N', vl_anterior_p text default null, ie_nulo_anterior_p text default 'N') FROM PUBLIC;
