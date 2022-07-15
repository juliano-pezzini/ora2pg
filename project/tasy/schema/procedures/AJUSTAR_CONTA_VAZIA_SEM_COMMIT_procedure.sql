-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajustar_conta_vazia_sem_commit ( nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* ATENÇÃO !!!!!!! NÃO COLOCAR COMMIT DENTRO DESSA PROCEDURE.  UTILIZADA EM OBJETOS QUE NÃO PODERÃO COMMIT. ATENÇÃO

!!!!!!!!!! */
ie_existe_registro_w		char(1);
nr_interno_conta_w			bigint;
ie_excluir_conta_vazia_w	varchar(1):= 'S';
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;

C01 CURSOR FOR
	SELECT	nr_interno_conta
	from	conta_paciente
	where	nr_atendimento = nr_atendimento_p
	and 	ie_status_acerto = 1
	order by nr_interno_conta;


BEGIN

begin
select	coalesce(a.cd_estabelecimento, c.cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	conta_paciente a,
	atendimento_paciente c,
	convenio b
where	coalesce(a.cd_convenio_calculo,a.cd_convenio_parametro) 	= b.cd_convenio
and	a.nr_atendimento	= nr_atendimento_p
and	a.nr_atendimento	= c.nr_atendimento;
exception
	when others then
	cd_estabelecimento_w := 0;
end;

ie_excluir_conta_vazia_w	:= coalesce(obter_valor_param_usuario(67, 675, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'S');

if (coalesce(ie_excluir_conta_vazia_w,'S') = 'S') then

	open C01;
	loop
	fetch C01 into
		nr_interno_conta_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		/* Deletar contas sem procedimentos e materiais */

		select 	coalesce(max('S'),'N')
		into STRICT	ie_existe_registro_w
		from 	procedimento_paciente where		nr_interno_conta = nr_interno_conta_w LIMIT 1;

		if (ie_existe_registro_w = 'N') then
			select 	coalesce(max('S'),'N')
			into STRICT	ie_existe_registro_w
			from 	material_atend_paciente where		nr_interno_conta		= nr_interno_conta_w LIMIT 1;

			if (ie_existe_registro_w = 'N') then
				begin
				delete from conta_paciente
				where nr_interno_conta = nr_interno_conta_w
				and ((Obter_Tipo_Convenio(cd_convenio_parametro) <> 3) or
			--'-Reinternação AIH 72 horas-'
					(obter_se_contido_char(ds_observacao,obter_desc_expressao(342126)) = 'N'));
				exception when others then
					null;
				end;
			end if;
		end if;

		end;
	end loop;
	close C01;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajustar_conta_vazia_sem_commit ( nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

