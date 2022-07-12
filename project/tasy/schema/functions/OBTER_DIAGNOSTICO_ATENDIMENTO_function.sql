-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_diagnostico_atendimento ( nr_atendimento_p bigint, ie_por_usuario_logado bigint default 0, ie_funcao_usa_episodio_p text default 'N') RETURNS varchar AS $body$
DECLARE


dt_diagnostico_w			timestamp;
ds_diagnostico_w			varchar(300);
cd_doenca_cid_w				varchar(10);
ie_possui_cid_no_tituli_w 	integer;
nr_seq_episodio_w			episodio_paciente.nr_sequencia%type;


/* ie_por_usuario_logado  1 true or 0 false */

BEGIN

if (obtain_user_locale(wheb_usuario_pck.get_nm_usuario) = 'de_DE' and obter_uso_case(wheb_usuario_pck.get_nm_usuario) = 'S' and ie_funcao_usa_episodio_p = 'S') then

	select	nr_seq_episodio
	into STRICT	nr_seq_episodio_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_p;
	
	ds_diagnostico_w := obter_diagnostico_episodio_ger(nr_seq_episodio_w, 0);
else
	cd_doenca_cid_w := '';

	begin
	select	max(dt_diagnostico)
	into STRICT 	dt_diagnostico_w
	from 	diagnostico_medico a
	where	nr_atendimento	= nr_atendimento_p
	and	exists	(	SELECT	1
				from	diagnostico_doenca x
				where	x.nr_atendimento	= a.nr_atendimento
				and	x.dt_diagnostico	= a.dt_diagnostico
				and	coalesce(x.dt_inativacao::text, '') = ''
				and     (	(ie_por_usuario_logado = 0) or (ie_por_usuario_logado = 1 and nm_usuario = Obter_Usuario_Ativo))
					);
	exception
		when no_data_found then
			dt_diagnostico_w := null;
	end;

	if (dt_diagnostico_w IS NOT NULL AND dt_diagnostico_w::text <> '') then
		select max(a.cd_doenca_cid), max(a.ds_doenca_cid)
        into STRICT	cd_doenca_cid_w, ds_diagnostico_w
        from (SELECT  max(cd_doenca_cid) cd_doenca_cid, coalesce(max(ds_doenca_cid),null)ds_doenca_cid
		from 	cid_doenca
		where	cd_doenca_cid = (	select max(cd_doenca)
						from	diagnostico_doenca
						where	nr_atendimento	= nr_atendimento_p
						  and	dt_diagnostico =	dt_diagnostico_w
						  and	coalesce(dt_inativacao::text, '') = ''
						  and   ((ie_por_usuario_logado = 0) or (ie_por_usuario_logado = 1 and nm_usuario = Obter_Usuario_Ativo))
					) and obtain_user_locale(wheb_usuario_pck.get_nm_usuario) <> 'ja_JP'

union

        SELECT max(cd_doenca),max(get_desc_modify_disease_epc(nr_seq_disease_number,ie_side_modifier,nr_seq_jap_pref_1,nr_seq_jap_pref_2,nr_seq_jap_pref_3, nr_seq_jap_sufi_1,nr_seq_jap_sufi_2,nr_seq_jap_sufi_3,nr_seq_interno))
        from diagnostico_doenca
        where	nr_atendimento	= nr_atendimento_p
						  and	dt_diagnostico =	dt_diagnostico_w
						  and	coalesce(dt_inativacao::text, '') = ''
						  and   ((ie_por_usuario_logado = 0) or (ie_por_usuario_logado = 1 and nm_usuario = Obter_Usuario_Ativo))
					 and obtain_user_locale(wheb_usuario_pck.get_nm_usuario) = 'ja_JP')a;

		if (coalesce(ds_diagnostico_w::text, '') = '') then
			select SUBSTR(ds_diagnostico,1,240)
			into STRICT ds_diagnostico_w
			from diagnostico_medico
			where nr_atendimento = nr_atendimento_p
			  and dt_diagnostico = dt_diagnostico_w
			  and (	 (ie_por_usuario_logado = 0) or (ie_por_usuario_logado = 1 and nm_usuario = Obter_Usuario_Ativo)
				  );
		end if;
		
		select INSTR(
				substr(cd_doenca_cid_w,1,3),
				substr(ds_diagnostico_w,1,3),1,1)
		into STRICT  ie_possui_cid_no_tituli_w
		;
		
		if (ie_possui_cid_no_tituli_w = 0) then
			ds_diagnostico_w := cd_doenca_cid_w || ' - ' || ds_diagnostico_w;
		end if;
	end if;
end if;

RETURN ds_diagnostico_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_diagnostico_atendimento ( nr_atendimento_p bigint, ie_por_usuario_logado bigint default 0, ie_funcao_usa_episodio_p text default 'N') FROM PUBLIC;

