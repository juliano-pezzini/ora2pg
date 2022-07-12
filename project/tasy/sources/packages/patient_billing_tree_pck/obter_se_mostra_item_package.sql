-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION patient_billing_tree_pck.obter_se_mostra_item (ie_item_p text, nr_seq_episodio_p episodio_paciente.nr_sequencia%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type) RETURNS varchar AS $body$
DECLARE


	ie_visualiza_w	varchar(1);
    ie_situacao_w   varchar(1);
	nr_seq_regra_w	bigint;
	ie_tipo_case_w	atendimento_paciente.ie_tipo_atendimento%type;

	c01 CURSOR FOR
	SELECT	ie_visualiza
	from	conta_regra_visual
	where	nr_seq_regra					= nr_seq_regra_w
	and	ie_situacao					= 'A'
	and	coalesce(ie_tipo_case,coalesce(ie_tipo_case_w,0))		= coalesce(ie_tipo_case_w,0)
	and	coalesce(cd_perfil,cd_perfil_p)			= cd_perfil_p
	and	coalesce(nm_usuario_regra,nm_usuario_p)		= nm_usuario_p
	order by	ie_tipo_case nulls first,
		cd_perfil nulls first;

	
BEGIN

	begin
	select	ie_situacao, nr_sequencia
	into STRICT	ie_situacao_w, nr_seq_regra_w
	from	conta_paciente_regra a
	where	a.ie_item_conta		= ie_item_p
	and	a.cd_estabelecimento	= cd_estabelecimento_p  LIMIT 1;
	exception
	when others then
		nr_seq_regra_w 	:= null;
        ie_situacao_w := 'A';
	end;

	if (coalesce(nr_seq_regra_w::text, '') = '' and ie_situacao_w = 'A') then
		ie_visualiza_w := 'S';
	elsif (ie_situacao_w = 'A') then
		if (nr_seq_episodio_p IS NOT NULL AND nr_seq_episodio_p::text <> '') then
			select	max(b.ie_tipo)
			into STRICT	ie_tipo_case_w
			from	tipo_episodio b,
				episodio_paciente a
			where	a.nr_seq_tipo_episodio	= b.nr_sequencia
			and	a.nr_sequencia		= nr_seq_episodio_p;
		elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
			select	max(ie_tipo_atendimento)
			into STRICT	ie_tipo_case_w
			from	atendimento_paciente
			where	nr_atendimento	= nr_atendimento_p;
		end if;

		open C01;
		loop
		fetch C01 into
			ie_visualiza_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		end loop;
		close C01;
    else ie_visualiza_w := 'N';
	end if;

	return	ie_visualiza_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION patient_billing_tree_pck.obter_se_mostra_item (ie_item_p text, nr_seq_episodio_p episodio_paciente.nr_sequencia%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
