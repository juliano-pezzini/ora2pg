-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_matproc_conta ( nr_sequencia_p bigint, nr_interno_conta_p bigint, cd_motivo_exc_conta_p bigint, ds_compl_motivo_excon_p text, ie_proc_mat_p text, nm_usuario_p text, ie_trigger_p text default null) AS $body$
DECLARE


nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
ie_calculo_taxa_regra_w	varchar(01);
ie_exclui_proc_laudo_w	varchar(2) := 'S';
ie_excluir_mat_autor_w	varchar(2) := 'N';
ie_existe_laudo_w		char(1);
nr_seq_mat_autor_w		bigint;
ie_valor_informado_w	material_atend_paciente.ie_valor_informado%type;

/*
ie_proc_mat_p
	P - procedimento
	M - matmed
*/
BEGIN
select	coalesce(max(ie_calculo_taxa_regra), 'C'),
		coalesce(max(ie_excluir_mat_autor), 'N')
into STRICT	ie_calculo_taxa_regra_w,
		ie_excluir_mat_autor_w
from	parametro_faturamento
where	cd_estabelecimento	= wheb_usuario_pck.get_cd_estabelecimento;

if (ie_proc_mat_p = 'M') then
	begin

	select	max(nr_atendimento),
			max(nr_seq_mat_autor),
			coalesce(max(ie_valor_informado_w),'N')
	into STRICT	nr_atendimento_w,
			nr_seq_mat_autor_w,
			ie_valor_informado_w
	from	material_atend_paciente
	where	nr_sequencia = nr_sequencia_p;

	update	material_atend_paciente
	set	cd_motivo_exc_conta	= cd_motivo_exc_conta_p,
		ds_compl_motivo_excon	= ds_compl_motivo_excon_p,
		dt_acerto_conta 	 = NULL,
		nr_interno_conta 	 = NULL,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		nr_seq_mat_autor	 = NULL
	where	nr_sequencia		= nr_sequencia_p;
	end;

	if (nr_seq_mat_autor_w IS NOT NULL AND nr_seq_mat_autor_w::text <> '') and (ie_excluir_mat_autor_w = 'S') then
		CALL excluir_material_autorizado(nr_atendimento_w,nr_seq_mat_autor_w,nr_sequencia_p,nm_usuario_p);
	end if;

	begin
	delete	from	auditoria_matpaci
	where	nr_seq_matpaci	= nr_sequencia_p;
	exception
	when others then
		null;
	end;

	if (ie_calculo_taxa_regra_w = 'L') and (ie_valor_informado_w = 'N')then
		CALL Calcular_Regra_Preco_Taxa(nr_interno_conta_p, nr_sequencia_p, 2, nm_usuario_p);
	end if;
else
	begin
	if (obter_funcao_ativa = 1125) then
		ie_exclui_proc_laudo_w := Obter_valor_param_usuario(1125,54,obter_perfil_ativo,nm_usuario_p,wheb_usuario_pck.get_cd_estabelecimento);
		if (ie_exclui_proc_laudo_w = 'N') then
			begin

			select	coalesce(max('S'),'N')
			into STRICT	ie_existe_laudo_w
			from	sus_laudo_paciente a,
					procedimento_paciente b where		a.cd_procedimento_solic = b.cd_procedimento
			and		a.nr_atendimento	= b.nr_atendimento
			and		b.nr_sequencia		= nr_sequencia_p LIMIT 1;

			if (ie_existe_laudo_w = 'N') then
				select	coalesce(max('S'),'N')
				into STRICT	ie_existe_laudo_w
				from	procedimento_paciente a,
						laudo_paciente b where		b.nr_sequencia	= a.nr_laudo
				and		a.nr_sequencia 	= nr_sequencia_p LIMIT 1;
			end if;

			if (ie_existe_laudo_w = 'S') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(189420);
				/* Procedimento não pode ser excluido pois possui laudo vinculado. Parâmetro [54]. */

			end if;
			end;
		end if;
	end if;

	select	max(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	procedimento_paciente
	where	nr_sequencia	= nr_sequencia_p;

	update	procedimento_paciente
	set	cd_motivo_exc_conta	= cd_motivo_exc_conta_p,
		ds_compl_motivo_excon	= ds_compl_motivo_excon_p,
		dt_acerto_conta 		 = NULL,
		nr_interno_conta 		 = NULL,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		nr_seq_proc_autor		 = NULL
	where	nr_sequencia		= nr_sequencia_p;
	begin
	delete	from auditoria_propaci
	where	nr_seq_propaci	= nr_sequencia_p;
	exception
	when others then
		null;
	end;

	if (ie_calculo_taxa_regra_w	= 'L') then
		CALL Calcular_Regra_Preco_Taxa(nr_interno_conta_p, nr_sequencia_p, 1, nm_usuario_p);
	end if;

	end;
end if;

if coalesce(ie_trigger_p::text, '') = '' then
  if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_matproc_conta ( nr_sequencia_p bigint, nr_interno_conta_p bigint, cd_motivo_exc_conta_p bigint, ds_compl_motivo_excon_p text, ie_proc_mat_p text, nm_usuario_p text, ie_trigger_p text default null) FROM PUBLIC;
