-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_liberado_terceiro (nr_seq_terceiro_p bigint) RETURNS bigint AS $body$
DECLARE

 
vl_retorno_w		double precision := 0;
vl_procedimento_w	double precision := 0;
vl_material_w		double precision := 0;
ie_estornado_w		varchar(1) := 'N';
cd_funcao_ativa_w	bigint  := 0;


BEGIN 
 
if (nr_seq_terceiro_p IS NOT NULL AND nr_seq_terceiro_p::text <> '') then 
	begin 
 
	/*cd_funcao_ativa_w := nvl(obter_funcao_ativa,0); 
	 
	if	(cd_funcao_ativa_w = 89) then*/
 
		ie_estornado_w := Obter_Param_Usuario(89, 164, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_estornado_w);
	/*end if;*/
 
	 
	if (coalesce(ie_estornado_w,'N') = 'N') then 
		select	coalesce(sum(coalesce(a.vl_liberado,0)),0) 
		into STRICT	vl_procedimento_w 
		from	procedimento_paciente b, 
			procedimento_repasse a 
		where	coalesce(a.nr_repasse_terceiro::text, '') = '' 
		and	a.nr_seq_terceiro		= nr_seq_terceiro_p 
		and	a.nr_seq_procedimento		= b.nr_sequencia 
		and	(b.nr_interno_conta IS NOT NULL AND b.nr_interno_conta::text <> '') 
		and	coalesce(b.cd_motivo_exc_conta::text, '') = '' 
		and	a.ie_status in ('L','R','S','E');
 
		select	coalesce(sum(coalesce(a.vl_liberado,0)),0) 
		into STRICT	vl_material_w 
		from	material_atend_paciente b, 
			material_repasse a 
		where	coalesce(a.nr_repasse_terceiro::text, '') = '' 
		and	a.nr_seq_terceiro	= nr_seq_terceiro_p 
		and	a.nr_seq_material	= b.nr_sequencia 
		and	(b.nr_interno_conta IS NOT NULL AND b.nr_interno_conta::text <> '') 
		and	coalesce(b.cd_motivo_exc_conta::text, '') = '' 
		and	a.ie_status in ('L','R','S','E');
	 
	elsif (coalesce(ie_estornado_w,'N') = 'S') then 
		 select coalesce(sum(a.vl_liberado),0) 
		 into STRICT	vl_procedimento_w 
		 FROM atend_paciente_unidade f, pessoa_fisica e, atendimento_paciente d, procedimento c, procedimento_paciente b
LEFT OUTER JOIN conta_paciente t ON (b.nr_interno_conta = t.nr_interno_conta)
LEFT OUTER JOIN convenio g ON (t.cd_convenio_parametro = g.cd_convenio)
, procedimento_repasse a
LEFT OUTER JOIN procmat_repasse_nf h ON (a.nr_sequencia = h.nr_seq_proc_repasse)
LEFT OUTER JOIN procedimento_participante j ON (a.nr_seq_procedimento = j.nr_sequencia AND a.nr_seq_partic = j.nr_seq_partic)
WHERE a.nr_seq_procedimento  = b.nr_sequencia  and b.cd_procedimento    = c.cd_procedimento and b.ie_origem_proced   = c.ie_origem_proced and b.nr_atendimento    = d.nr_atendimento and d.cd_pessoa_fisica   = e.cd_pessoa_fisica   and b.nr_seq_atepacu    = f.nr_seq_interno   and a.ie_status       not in ('P','E') and coalesce(a.ie_estorno,'N') = 'N' and a.nr_seq_terceiro    = nr_seq_terceiro_p and coalesce(a.nr_repasse_terceiro::text, '') = '' and not exists (	SELECT 1 from procedimento_repasse x where 
					x.nr_seq_origem = a.nr_sequencia and x.ie_status = 'E');
 
		select	coalesce(sum(coalesce(a.vl_liberado,0)),0) 
		into STRICT	vl_material_w 
		from	material_atend_paciente b, 
			material_repasse a 
		where	coalesce(a.nr_repasse_terceiro::text, '') = '' 
		and	a.nr_seq_terceiro	= nr_seq_terceiro_p 
		and	a.nr_seq_material	= b.nr_sequencia 
		and	(b.nr_interno_conta IS NOT NULL AND b.nr_interno_conta::text <> '') 
		and	coalesce(b.cd_motivo_exc_conta::text, '') = '' 
		and	a.ie_status	 <> 'E' 
		and 	not exists (	SELECT 1 from material_repasse x where 
					x.nr_seq_origem = a.nr_sequencia and x.ie_status = 'E');
	end if;
	 
	vl_retorno_w	:= coalesce(vl_procedimento_w,0) + coalesce(vl_material_w,0);
 
	end;
end if;
 
return	vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_liberado_terceiro (nr_seq_terceiro_p bigint) FROM PUBLIC;

