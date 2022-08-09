-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_guia_imp_ant ( nr_seq_guia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_usuario_plano_w		varchar(30);
cd_cnes_imp_w			varchar(20);
nm_medico_solicitante_imp_w	varchar(255);
cd_usuario_plano_imp_w		varchar(30);
nr_seq_prestador_imp_w		varchar(20);
cd_medico_w			bigint;
qt_benef_valido_w		integer;
qt_prestador_valido_w		integer	:= 0;
cd_cnes_w			varchar(20);
ie_tipo_doenca_imp_w		varchar(1);
ie_indicacao_acidente_imp_w	varchar(1);
cd_doenca_imp_w			varchar(10);
nr_seq_guia_proc_w		bigint;
cd_procedimento_imp_w		bigint;
cd_tipo_tabela_imp_w		varchar(20);
ie_origem_proced_w		bigint;
nr_seq_guia_mat_w		bigint;
cd_material_imp_w		integer;
nr_prestador_valido_w		numeric(20);
cd_cgc_prestador_imp_w		varchar(14);
cd_cpf_prestador_imp_w		varchar(11);
nr_seq_prestador_w		bigint;
dt_solicitacao_imp_w		timestamp;
ie_origem_solic_w		pls_guia_plano.ie_origem_solic%type;
ie_tipo_guia_w			pls_guia_plano.ie_tipo_guia%type;

c01 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_procedimento_imp, 
		cd_tipo_tabela_imp 
	from	pls_guia_plano_proc 
	where	nr_seq_guia	= nr_seq_guia_p;

c02 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_material_imp 
	from	pls_guia_plano_mat 
	where	nr_seq_guia	= nr_seq_guia_p;

c03 CURSOR FOR 
	SELECT	ie_tipo_doenca_imp, 
		ie_indicacao_acidente_imp, 
		cd_doenca_imp 
	from	pls_diagnostico 
	where	nr_seq_guia	= nr_seq_guia_p;


BEGIN 
 
select	cd_cnes_imp, 
	upper(elimina_acentuacao(nm_medico_solicitante_imp)), 
	cd_usuario_plano_imp,	 
	nr_seq_prestador_imp,	 
	cd_cgc_prestador_imp, 
	cd_cpf_prestador_imp, 
	dt_solicitacao_imp, 
	ie_origem_solic, 
	ie_tipo_guia 
into STRICT	cd_cnes_imp_w, 
	nm_medico_solicitante_imp_w, 
	cd_usuario_plano_imp_w,	 
	nr_seq_prestador_imp_w,	 
	cd_cgc_prestador_imp_w, 
	cd_cpf_prestador_imp_w, 
	dt_solicitacao_imp_w, 
	ie_origem_solic_w, 
	ie_tipo_guia_w 
from	pls_guia_plano 
where	nr_sequencia	= nr_seq_guia_p;
 
select	coalesce(max(cd_usuario_plano),0) 
into STRICT	cd_usuario_plano_w 
from	pls_segurado_carteira 
where	cd_usuario_plano = cd_usuario_plano_imp_w 
and	dt_inicio_vigencia <= clock_timestamp() 
and	coalesce(dt_validade_carteira,clock_timestamp()) >= clock_timestamp();
 
if (cd_usuario_plano_w = 0) then 
	CALL pls_gravar_motivo_glosa('1001',nr_seq_guia_p,null,null,'',nm_usuario_p,'','IG',nr_seq_prestador_imp_w, null,null);
else 
	select	count(*) 
	into STRICT	qt_benef_valido_w 
	from	pls_segurado_carteira b, 
		pls_segurado a 
	where	a.nr_sequencia		= b.nr_seq_segurado 
	and	b.cd_usuario_plano	= cd_usuario_plano_w 
	and	coalesce(dt_validade_carteira,clock_timestamp()) >= clock_timestamp() 
	and	dt_inicio_vigencia <= clock_timestamp();
	 
	if (qt_benef_valido_w = 0) then 
		CALL pls_gravar_motivo_glosa('1017',nr_seq_guia_p,null,null,'',nm_usuario_p,'','IG',nr_seq_prestador_imp_w, null,null);
	end if;
 
	select	somente_numero(nr_seq_prestador_imp_w) 
	into STRICT	nr_prestador_valido_w 
	;
	 
	if (nr_seq_prestador_imp_w <> to_char(nr_prestador_valido_w)) then 
		CALL pls_gravar_motivo_glosa('1203',nr_seq_guia_p,null,null,'',nm_usuario_p,'','IG',nr_seq_prestador_imp_w, null,null);
	else 
	 
		/* Obter os prestadores da conta */
 
		nr_seq_prestador_w	:= pls_obter_prestador_imp(cd_cgc_prestador_imp_w, cd_cpf_prestador_imp_w, nr_seq_prestador_imp_w, '', '', '');
		 
		if (nr_seq_prestador_w > 0) then			 
		 
			select	substr(pls_obter_dados_prestador(nr_sequencia,'CNES'),1,255) 
			into STRICT	cd_cnes_w 
			from	pls_prestador 
			where	nr_sequencia	= nr_seq_prestador_w;
 
			if (cd_cnes_w <> cd_cnes_imp_w) then 
				CALL pls_gravar_motivo_glosa('1202',nr_seq_guia_p,null,null,'',nm_usuario_p,'','IG',nr_seq_prestador_w, null,null);
			end if;
 
			select	coalesce(max(somente_numero(cd_medico)),0) 
			into STRICT	cd_medico_w 
			from	pls_prestador_medico 
			where	nr_seq_prestador = nr_seq_prestador_w 
			and	upper(elimina_acentuacao(substr(obter_nome_medico(cd_medico,'N'),1,255))) = nm_medico_solicitante_imp_w 
			and	ie_situacao	= 'A' 
			and	trunc(coalesce(dt_solicitacao_imp_w,clock_timestamp()),'dd') between trunc(coalesce(dt_inclusao,coalesce(dt_solicitacao_imp_w,clock_timestamp())),'dd') and fim_dia(coalesce(dt_exclusao,coalesce(dt_solicitacao_imp_w,clock_timestamp())));
 
			if (cd_medico_w = 0) then 
				CALL pls_gravar_motivo_glosa('1210',nr_seq_guia_p,null,null,'',nm_usuario_p,'','IG',nr_seq_prestador_w, null,null);
			end if;
 
			if (nm_medico_solicitante_imp_w = '') then 
				CALL pls_gravar_motivo_glosa('1411',nr_seq_guia_p,null,null,'',nm_usuario_p,'','IG',nr_seq_prestador_w, null,null);
			end if;
		else 
			CALL pls_gravar_motivo_glosa('1203',nr_seq_guia_p,null,null,'',nm_usuario_p,'','IG',nr_seq_prestador_w, null,null);
		end if;
	end if;
 
	open c01;
	loop 
	fetch c01 into	 
		nr_seq_guia_proc_w, 
		cd_procedimento_imp_w, 
		cd_tipo_tabela_imp_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		if (cd_tipo_tabela_imp_w in ('01','02','03','04','07','08')) then 
			ie_origem_proced_w	:= 1;
		elsif (cd_tipo_tabela_imp_w = '06') then 
			ie_origem_proced_w	:= 5;
		elsif (cd_tipo_tabela_imp_w = '10') then 
			ie_origem_proced_w	:= 3;
		elsif (cd_tipo_tabela_imp_w = '11') then 
			ie_origem_proced_w	:= 2;
		else 
			ie_origem_proced_w	:= 4;
		end if;
 
		begin 
		select	cd_procedimento 
		into STRICT	cd_procedimento_imp_w 
		from	procedimento 
		where	cd_procedimento		= cd_procedimento_imp_w 
		and	ie_origem_proced	= ie_origem_proced_w;
		exception 
			when others then 
				CALL pls_gravar_motivo_glosa('1801',null,nr_seq_guia_proc_w,null,'',nm_usuario_p,'','IG',nr_seq_prestador_w, null,null);
				cd_procedimento_imp_w	:= null;
				ie_origem_proced_w	:= null;
		end;
	end loop;
	close c01;
 
	open c02;
	loop 
	fetch c02 into	 
		nr_seq_guia_mat_w, 
		cd_material_imp_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		if (coalesce(cd_material_imp_w::text, '') = '') then 
			CALL pls_gravar_motivo_glosa('2003',nr_seq_guia_p,null,null,'',nm_usuario_p,'','IG',nr_seq_prestador_w, null,null);
		else 
			begin 
			select	cd_material 
			into STRICT	cd_material_imp_w 
			from	material 
			where	cd_material	= cd_material_imp_w;
			exception 
				when others then 
					CALL pls_gravar_motivo_glosa('2001',null,null,nr_seq_guia_mat_w,'',nm_usuario_p,'','IG',nr_seq_prestador_w, null,null);
					cd_material_imp_w	:= null;
			end;
		end if;
	end loop;
	close c02;
 
	open c03;
	loop 
	fetch c03 into	 
		ie_tipo_doenca_imp_w, 
		ie_indicacao_acidente_imp_w, 
		cd_doenca_imp_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		if (ie_tipo_doenca_imp_w <> 'A') and (ie_tipo_doenca_imp_w <> 'C') then 
			CALL pls_gravar_motivo_glosa('1502',nr_seq_guia_p,null,null,'',nm_usuario_p,'','IG',nr_seq_prestador_w, null,null);
			ie_tipo_doenca_imp_w	:= '';
		end if;
 
		if (ie_indicacao_acidente_imp_w <> '0') and (ie_indicacao_acidente_imp_w <> '1') and (ie_indicacao_acidente_imp_w <> '2') and 
			((ie_origem_solic_w <> 'E') or (ie_origem_solic_w = 'E' and ie_tipo_guia_w = 1)) then 
				---Para as guias geradas pelo WebService ( ie_origem_solic = 'E') , só deverá consistir a Glosa se o tipo de guia for de internação. 
				CALL pls_gravar_motivo_glosa('1503',nr_seq_guia_p,null,null,'',nm_usuario_p,'','IG',nr_seq_prestador_w, null,null);
				ie_indicacao_acidente_imp_w	:= '';
		end if;
 
		if (cd_doenca_imp_w = '') then 
			CALL pls_gravar_motivo_glosa('1508',nr_seq_guia_p,null,null,'',nm_usuario_p,'','IG',nr_seq_prestador_w, null,null);
		else 
			begin 
			select	cd_doenca_cid 
			into STRICT	cd_doenca_imp_w 
			from	cid_doenca 
			where	cd_doenca_cid	= cd_doenca_imp_w;
			exception 
				when others then 
					CALL pls_gravar_motivo_glosa('1509', nr_seq_guia_p,null,null,'',nm_usuario_p,'','IG',nr_seq_prestador_w, null,null);
					cd_doenca_imp_w	:= null;
			end;
		end if;
 
	end loop;
	close c03;
end if;
 
update	pls_guia_plano 
set	ie_estagio	= 7 
where	nr_sequencia	= nr_seq_guia_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_guia_imp_ant ( nr_seq_guia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
