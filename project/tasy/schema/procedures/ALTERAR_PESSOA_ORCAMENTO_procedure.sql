-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_pessoa_orcamento ( nr_sequencia_orcamento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
DECLARE


qt_registro_w		bigint;
ie_vincula_pf_obito_w	varchar(2);


BEGIN

ie_vincula_pf_obito_w := obter_param_usuario(106, 147, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_vincula_pf_obito_w);

if (ie_vincula_pf_obito_w = 'N') then
	select 	count(1)
	into STRICT	qt_registro_w
	from   	pessoa_fisica
	where  	cd_pessoa_fisica = cd_pessoa_fisica_p
	and 	(dt_obito IS NOT NULL AND dt_obito::text <> '');

	if (qt_registro_w > 0) then
		/*O paciente possui óbito informado, e não é permitido criar/vincular um novo orçamento. Parâmetro [147]*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(1006590);
	end if;
end if;

select	count(*)
into STRICT	qt_registro_w
from	pessoa_fisica
where	cd_pessoa_fisica = cd_pessoa_fisica_p;

if (qt_registro_w > 0) then
		update	orcamento_paciente
		set		cd_pessoa_fisica	= cd_pessoa_fisica_p,
				nm_usuario			= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
		where	nr_sequencia_orcamento = nr_sequencia_orcamento_p
		and		coalesce(nr_atendimento::text, '') = '';
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_pessoa_orcamento ( nr_sequencia_orcamento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;
