-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estagio_autor_atecaco ( nr_atendimento_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint default null, ie_origem_proced_p bigint default null, nr_seq_proc_interno_p bigint default null, ie_lado_p text default null, dt_inicio_vigencia_p timestamp default null, dt_final_vigencia_p timestamp default null) RETURNS varchar AS $body$
DECLARE


qt_autor_pend_w		integer;
ds_retorno_w		varchar(255) :='';
qt_autorizacao_w	integer;
nr_sequencia_w		autorizacao_convenio.nr_sequencia%type;
cd_convenio_w		bigint;

ds_sql_w		varchar(4000) := '';
ds_sql_param_w		varchar(4000);

ie_tipo_atendimento_w atendimento_paciente.ie_tipo_atendimento%type;


BEGIN
nr_sequencia_w := 0;
If (coalesce(cd_convenio_p::text, '') = '') then
	cd_convenio_w := obter_convenio_atendimento(nr_atendimento_p);
else
	cd_convenio_w := cd_convenio_p;
end if;

ie_tipo_atendimento_w := obter_tipo_atendimento(nr_atendimento_p);

-- If the procedure code is not specified, we query based on the encounter number and insurance code alone
if	coalesce(cd_procedimento_p::text, '') = '' and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	    ds_sql_w := ds_sql_w || 'select nr_sequencia  ';
        ds_sql_w := ds_sql_w || 'from (select a.nr_sequencia	';
        ds_sql_w := ds_sql_w || 'from	autorizacao_convenio a 		';
        ds_sql_w := ds_sql_w || 'where	a.nr_atendimento = :nr_atendimento_p ';
        ds_sql_w := ds_sql_w || 'and	a.cd_convenio    = :cd_convenio_p ';

	    ds_sql_param_w := 	''
                            ||'NR_ATENDIMENTO_P='	||	nr_atendimento_p	||';'
                            ||'CD_CONVENIO_P='	||	cd_convenio_w		;

        if (dt_inicio_vigencia_p IS NOT NULL AND dt_inicio_vigencia_p::text <> '') then
            ds_sql_w := ds_sql_w                || ' and 	a.dt_inicio_vigencia  >= :dt_inicio_vigencia_p    	';
            ds_sql_param_w := ds_sql_param_w    ||';DT_INICIO_VIGENCIA_P='	||	dt_inicio_vigencia_p;
        end if;

        if (dt_final_vigencia_p IS NOT NULL AND dt_final_vigencia_p::text <> '') then
            ds_sql_w 		:= ds_sql_w 		|| ' and     Nvl(a.dt_fim_vigencia,sysdate) <= fim_dia(:dt_final_vigencia_p)    	';
            ds_sql_param_w 	:= ds_sql_param_w  	||';DT_FINAL_VIGENCIA_P='	||	dt_final_vigencia_p;
        end if;

        if (ie_tipo_atendimento_w = 1) then
            ds_sql_w := ds_sql_w || ' and a.ie_tipo_autorizacao in (1, 2, 5) ';
            ds_sql_w := ds_sql_w || ' and (a.ie_tipo_autorizacao <> 5  or (a.ie_tipo_autorizacao = 5 and a.qt_dia_solicitado > 0 and a.qt_dia_autorizado > 0)) ';
        end if;

        ds_sql_w := ds_sql_w  || 'order by a.dt_inicio_vigencia desc)    	';
        ds_sql_w := ds_sql_w  || 'where rownum = 1     	';

        nr_sequencia_w := obter_valor_dinamico_bv(ds_sql_w, ds_sql_param_w, nr_sequencia_w);

-- Otherwise, if the procedure code is specified, we build the query dynamically
elsif (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then
	ds_sql_w := ds_sql_w || 'select max(a.nr_sequencia) nr_sequencia            	';
	ds_sql_w := ds_sql_w || 'from 	autorizacao_convenio a,		            	';
	ds_sql_w := ds_sql_w || '	procedimento_autorizado b	            	';
	ds_sql_w := ds_sql_w || 'where 	a.nr_sequencia 	   = b.nr_sequencia_autor (+) 	';
	ds_sql_w := ds_sql_w || 'and	a.nr_atendimento   = :nr_atendimento_p        	';
	ds_sql_w := ds_sql_w || 'and 	a.cd_convenio 	   = :cd_convenio_p	    	';
	ds_sql_w := ds_sql_w || 'and	b.cd_procedimento  = :cd_procedimento_p	    	';
	ds_sql_w := ds_sql_w || 'and	b.ie_origem_proced = :ie_origem_proced_p    	';

	ds_sql_param_w := ''
	||'NR_ATENDIMENTO_P='	||	nr_atendimento_p	||';'
	||'CD_CONVENIO_P='	||	cd_convenio_w		||';'
	||'CD_PROCEDIMENTO_P='	||	cd_procedimento_p	||';'
	||'IE_ORIGEM_PROCED_P='	||	ie_origem_proced_p	;

	if	(nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then
		ds_sql_w 	:= ds_sql_w 		|| ' and b.nr_seq_proc_interno = :nr_seq_proc_interno_p ';
		ds_sql_param_w 	:= ds_sql_param_w 	|| ';NR_SEQ_PROC_INTERNO_P='||nr_seq_proc_interno_p;
	end if;

	if	(ie_lado_p IS NOT NULL AND ie_lado_p::text <> '') then
		ds_sql_w 	:= ds_sql_w 		|| ' and b.ie_lado = :ie_lado_p ';
		ds_sql_param_w 	:= ds_sql_param_w 	|| ';IE_LADO_P='||ie_lado_p;
	end if;	

    	if (dt_inicio_vigencia_p IS NOT NULL AND dt_inicio_vigencia_p::text <> '') then
            ds_sql_w := ds_sql_w                || ' and 	a.dt_inicio_vigencia  >= :dt_inicio_vigencia_p    	';
            ds_sql_param_w := ds_sql_param_w    ||';DT_INICIO_VIGENCIA_P='	||	dt_inicio_vigencia_p;
        end if;

        if (dt_final_vigencia_p IS NOT NULL AND dt_final_vigencia_p::text <> '') then
            ds_sql_w 		:= ds_sql_w 		|| ' and     Nvl(a.dt_fim_vigencia,sysdate) <= fim_dia(:dt_final_vigencia_p)    	';
            ds_sql_param_w 	:= ds_sql_param_w  	||';DT_FINAL_VIGENCIA_P='	||	dt_final_vigencia_p;
        end if;	

        if (ie_tipo_atendimento_w = 1) then
            ds_sql_w := ds_sql_w || ' and a.ie_tipo_autorizacao in (1, 2) ';
        end if;

        ds_sql_w := ds_sql_w                || 'order by a.dt_fim_vigencia desc)    	';

	nr_sequencia_w := obter_valor_dinamico_bv(ds_sql_w, ds_sql_param_w, nr_sequencia_w);

end if;

if (nr_sequencia_w > 0) then
	select	max(substr(obter_estagio_autor(nr_seq_estagio, 'D'), 1, 255))
	into STRICT	ds_retorno_w
	from	autorizacao_convenio
	where	nr_sequencia 	= nr_sequencia_w;
else
	ds_retorno_w := null;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estagio_autor_atecaco ( nr_atendimento_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint default null, ie_origem_proced_p bigint default null, nr_seq_proc_interno_p bigint default null, ie_lado_p text default null, dt_inicio_vigencia_p timestamp default null, dt_final_vigencia_p timestamp default null) FROM PUBLIC;

