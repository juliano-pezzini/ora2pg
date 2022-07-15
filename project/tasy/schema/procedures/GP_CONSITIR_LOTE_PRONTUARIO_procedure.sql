-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gp_consitir_lote_prontuario ( nr_seq_lote_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ie_existe_prontuario_w		varchar(1) := 'N';
ie_solic_pront_w		varchar(1) := 'N';
ie_solic_pront_inexistente_w	varchar(1) := 'N';

/*Parâmetros*/

VarPermiteMesmoProntuarioLote	varchar(1);
VarFormaSolicPront		varchar(1);


BEGIN

VarPermiteMesmoProntuarioLote	:= coalesce(Obter_Valor_Param_Usuario(941, 132, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p),'S');
VarFormaSolicPront		:= coalesce(Obter_Valor_Param_Usuario(941, 26, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p),'N');
ie_solic_pront_inexistente_w	:= coalesce(Obter_Valor_Param_Usuario(941, 136, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p),'N');

begin
select	'S'
into STRICT	ie_existe_prontuario_w
from	same_prontuario a
where	a.ie_status not in ('2','5','6','10')
and	((coalesce(cd_pessoa_fisica_p, '0') = '0') or (a.cd_pessoa_fisica = cd_pessoa_fisica_p ))
and	((coalesce(nr_atendimento_p, 0) = 0) or (a.nr_atendimento = nr_atendimento_p ))
and    ((((a.dt_periodo_inicial IS NOT NULL AND a.dt_periodo_inicial::text <> '') /*and a.dt_periodo_final   is not null*/
) and ie_solic_pront_inexistente_w <> 'D')
	or (ie_solic_pront_inexistente_w = 'D'))  LIMIT 1;
exception
when others then
	ie_existe_prontuario_w	:= 'N';
end;

if (ie_existe_prontuario_w = 'N') and (ie_solic_pront_inexistente_w <> 'S') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(85297);
end if;


if (VarPermiteMesmoProntuarioLote = 'N') and (VarFormaSolicPront = 'N') then
	begin
	select	'S'
	into STRICT	ie_solic_pront_w
	from	same_solic_pront a
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_p
	and	a.nr_seq_lote = nr_seq_lote_p  LIMIT 1;
	exception
	when others then
		ie_solic_pront_w := 'N';
	end;

	if (ie_solic_pront_w = 'S') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(83699);
	end if;
end if;



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gp_consitir_lote_prontuario ( nr_seq_lote_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

