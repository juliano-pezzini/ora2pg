-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_interface_padrao_wheb ( cd_interface_p bigint, ie_substitui_p text, nm_usuario_p text) AS $body$
DECLARE


cd_interface_w          interface.cd_interface%type;
cd_interface_reg_w      interface.cd_interface%type;
cd_interface_atr_w      interface.cd_interface%type;
ds_comando_w		varchar(2000);


BEGIN

begin
select	max(cd_interface)
into STRICT	cd_interface_atr_w
from 	interface_atributo 
where 	cd_interface = cd_interface_p;
exception
        when others then
        cd_interface_atr_w := null;
        end;

begin
select	max(cd_interface)
into STRICT	cd_interface_reg_w
from 	interface_reg 
where 	cd_interface = cd_interface_p;
exception
        when others then
        cd_interface_reg_w := null;
        end;

begin
select	max(cd_interface)
into STRICT	cd_interface_w
from 	interface 
where 	cd_interface = cd_interface_p;
exception
        when others then
        cd_interface_w := null;
        end;

if      ((coalesce(cd_interface_atr_w,0) > 0) or (coalesce(cd_interface_reg_w,0) > 0) or (coalesce(cd_interface_w,0) > 0)) then

        cd_interface_w := coalesce(cd_interface_atr_w,cd_interface_reg_w,cd_interface_w);

	if ie_substitui_p = 'S' then
		delete from interface_atributo
		where	cd_interface = cd_interface_w;
		delete from interface_reg
		where	cd_interface = cd_interface_w;
		delete from interface
		where	cd_interface = cd_interface_w;
	else
                CALL Wheb_mensagem_pck.exibir_mensagem_abort(279297);
	end if;
end if;

ds_comando_w := ' insert into interface (' ||
		'		CD_INTERFACE,' ||
		'		DS_INTERFACE,' ||
		'		NM_ARQUIVO_SAIDA,'||
		'		DT_ATUALIZACAO,'||
		'		NM_USUARIO,'||
		'		IE_IMPLANTAR,'||
		'		CD_TIPO_INTERFACE,'||
		'		DS_COMANDO)'||
		' select	CD_INTERFACE,'||
		'		DS_INTERFACE,'||
		'		NM_ARQUIVO_SAIDA,'||
		'		DT_ATUALIZACAO,'||
		'		NM_USUARIO,'||
		'		IE_IMPLANTAR,'||
		'		CD_TIPO_INTERFACE,'||
		'		DS_COMANDO'||
		' from		tasy_versao.interface'||
		' where		cd_interface = :cd_interface';

CALL exec_sql_dinamico_bv('TABELA INTERFACE',ds_comando_w,'cd_interface='|| to_char(cd_interface_p));

ds_comando_w := ' insert into interface_reg ('||
		'		CD_INTERFACE,'||
		'		CD_REG_INTERFACE,'||
		'		DS_REG_INTERFACE,'||
		'		IE_SEPARADOR_REG,'||
		'		IE_FORMATO_REG,'||
		'		DT_ATUALIZACAO,'||
		'		NM_USUARIO,'||
		'		IE_REGISTRO,'||
		'		IE_TIPO_REGISTRO)'||
		' select	CD_INTERFACE,'||
		'		CD_REG_INTERFACE,'||
		'		DS_REG_INTERFACE,'||
		'		IE_SEPARADOR_REG,'||
		'		IE_FORMATO_REG,'||
		'		DT_ATUALIZACAO,'||
		'		NM_USUARIO,'||
		'		IE_REGISTRO,'||
		'		IE_TIPO_REGISTRO'||
		' from		tasy_versao.interface_reg'||
		' where		cd_interface = :cd_interface';

CALL exec_sql_dinamico_bv('TABELA INTERFACE_REG',ds_comando_w,'cd_interface='|| to_char(cd_interface_p));

ds_comando_w := ' insert into interface_atributo ( '||
		'		CD_INTERFACE,'||
		'		CD_REG_INTERFACE,'||
		'		NR_SEQ_ATRIBUTO,'||
		'		NM_TABELA,'||
		'		NM_ATRIBUTO,'||
		'		IE_TIPO_ATRIBUTO,'||
		'		QT_TAMANHO,'||
		'		DT_ATUALIZACAO,'||
		'		NM_USUARIO,'||
		'		QT_DECIMAIS,'||
		'		DS_MASCARA_DATA,'||
		'		DS_VALOR,'||
		'		QT_POSICAO_INICIAL,'||
		'		IE_IMPORTA_TABELA,'||
		'		DS_REGRA_VALIDACAO,'||
		'		IE_IDENTIFICA_ERRO,'||
		'		IE_EXPORTA,'||
		'		IE_TIPO_CAMPO,'||
		'		IE_CONVERSAO,'||
		'		NM_ATRIB_USUARIO)'||
		' select 	CD_INTERFACE,'||
		'		CD_REG_INTERFACE,'||
		'		NR_SEQ_ATRIBUTO,'||
		'		NM_TABELA,'||
		'		NM_ATRIBUTO,'||
		'		IE_TIPO_ATRIBUTO,'||
		'		QT_TAMANHO,'||
		'		DT_ATUALIZACAO,'||
		'		NM_USUARIO,'||
		'		QT_DECIMAIS,'||
		'		DS_MASCARA_DATA,'||
		'		DS_VALOR,'||
		'		QT_POSICAO_INICIAL,'||
		'		IE_IMPORTA_TABELA,'||
		'		DS_REGRA_VALIDACAO,'||
		'		IE_IDENTIFICA_ERRO,'||
		'		IE_EXPORTA,'||
		'		IE_TIPO_CAMPO,'||
		'		IE_CONVERSAO,'||
		'		NM_ATRIB_USUARIO'||
		' from		tasy_versao.interface_atributo'||
		' where		cd_interface = :cd_interface';

CALL exec_sql_dinamico_bv('TABELA INTERFACE_REG',ds_comando_w,'cd_interface='|| to_char(cd_interface_p));

commit;	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_interface_padrao_wheb ( cd_interface_p bigint, ie_substitui_p text, nm_usuario_p text) FROM PUBLIC;
