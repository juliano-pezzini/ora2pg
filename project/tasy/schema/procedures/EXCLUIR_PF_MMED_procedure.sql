-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_pf_mmed (nr_prontuario_p text, /*  V11 */
 ds_retorno_p INOUT text /*  V255 */
) AS $body$
DECLARE

/*objeto chamada no integração da multimed, os novos parâmetros que forem adicionados devem ser definidos como default para não ocorrer problemas na integração*/

/* Havia conflito em 4 campos na correlação:
NM_PESSOA_PESQUISA          	NOMEFONETICO  - Desconsiderado
DS_FONETICA                 	NOMEFONETICO - Considerado
NR_IDENTIDADE          	RG DO PACIENTE - Desconsiderado
NR_CPF                 		CPF DO PACIENTE - Desconsiderado

*/
ie_erro_compl_pf_w	varchar(1)	:= 'N';
ie_erro_pf_w		varchar(1)	:= 'N';
qt_registro_w		bigint;
nr_sequencia_w		bigint;
cd_pessoa_fisica_w	varchar(10);
sql_errm_w		varchar(2000);
ds_retorno_w		varchar(255) := '';
qt_compl_w		bigint;



BEGIN

CALL wheb_usuario_pck.SET_IE_EXECUTAR_TRIGGER('N');

if (nr_prontuario_p IS NOT NULL AND nr_prontuario_p::text <> '') then

	select	count(*)
	into STRICT	qt_registro_w
	from	pessoa_fisica
	where	nr_prontuario = nr_prontuario_p;

	if (qt_registro_w = 0) then

		ds_retorno_w := Wheb_mensagem_pck.get_texto(308157, 'NR_PRONTUARIO_P='||nr_prontuario_p); --'Não existe pessoa física cadastrada com o prontuário ' || nr_prontuario_p;
		ie_erro_pf_w	:= 'S';
	end if;
end if;

if (ie_erro_pf_w = 'N') then

	select	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	pessoa_fisica
	where	nr_prontuario = nr_prontuario_p;

	begin

	delete from pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_w;
	exception
		when others then
		sql_errm_w	:= sqlerrm;
		ds_retorno_w := Wheb_mensagem_pck.get_texto(308158) || ' ' /*'Erro ao excluir a pessoa física. '*/|| sql_errm_w;

	end;

end if;
CALL wheb_usuario_pck.SET_IE_EXECUTAR_TRIGGER('S');

ds_retorno_p := ds_retorno_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_pf_mmed (nr_prontuario_p text,  ds_retorno_p INOUT text  ) FROM PUBLIC;

